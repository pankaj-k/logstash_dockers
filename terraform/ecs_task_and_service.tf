resource "aws_ecs_task_definition" "logstash_task" {
  family                   = "logstash-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 1024
  memory                   = 2048
  execution_role_arn       = aws_iam_role.ecs_role.arn
  task_role_arn            = aws_iam_role.logstash_role.arn

  # It is important to note that container_definations is actually coming from AWS. Terraform has not much to do with it.
  # To see the fields allowed, go to: 
  container_definitions = jsonencode([
    {
      name  = "logstash"
      image = "${aws_ecr_repository.custom_logstash_docker_private_repo.repository_url}:latest"
      # image     = "${aws_ecr_repository.logstash.repository_url}:latest"
      essential = true

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "${aws_cloudwatch_log_group.ecs_logstash.name}"
          "awslogs-region"        = var.region
          "awslogs-stream-prefix" = "ecs"
        }
      }

      portMappings = [
        {
          containerPort = 5044
          hostPort      = 5044
          protocol      = "tcp"
        }
      ]
      # 

      # The logstash in the container is not run as a system service, the entrypoint in the image 
      # will start a process and will keep the container up until this process ends or fails. The JVM runs directly as PID1. 
      # To simulate an error you have to log inside the container and kill the JVM process. Command: kill -15 1
      # A new task will be created.

      # Command to log inside the container:
      # aws ecs execute-command --cluster logstash_ecs_fargate_cluster --task <taskid> --container logstash --interactive --command "/bin/sh"

      # The health check command took 3 days to get it right. Essentially it is checking if the status is green or not. 
      # Do not ask me about stupidity around \\\. 

      healthCheck = {
        command     = ["CMD-SHELL", "curl -s http://localhost:9600/ | grep -q \\\"status\\\":\\\"green\\\" || exit 1"]
        interval    = 30  #Checks every 30 seconds.
        timeout     = 5   # Waits 5 seconds for a response.
        retries     = 3   # Fails after 3 unsuccessful attempts.
        startPeriod = 120 # Waits 120 seconds before the first check (gives Logstash more time to start).
      }
    }
  ])

  tags = {
    Name = "logstash-ecs-fargate"
  }
}

resource "aws_ecs_service" "logstash_service" {
  name            = "logstash-service"
  cluster         = aws_ecs_cluster.logstash_cluster.id
  task_definition = aws_ecs_task_definition.logstash_task.arn
  desired_count   = 3 # Run 3 tasks in 3 different AZs by default
  launch_type     = "FARGATE"

  enable_execute_command = true # Enable Execute Command outside container. 
  # Comment this out later as it is just for debugging. Essnetially I was running some container commands 
  # from the aws cloudshell console.

  network_configuration {
    subnets          = [aws_subnet.publicA.id, aws_subnet.publicB.id, aws_subnet.publicC.id]
    security_groups  = [aws_security_group.logstash_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.aws_load_balancer_target_group.arn
    container_name   = "logstash"
    container_port   = 5044
  }

  # There is a chance the policy might get destoryed too soon and ECS service will be stuck in DRAINING state.
  # So, we need to make sure that the policy is destroyed after the service is destroyed.
  depends_on = [aws_iam_policy.ecs_role_policy]

  tags = {
    Name = "logstash-service"
  }
}


# Auto scaling the tasks count
resource "aws_appautoscaling_target" "ecs_target" {
  max_capacity       = 6
  min_capacity       = 3 # 3
  resource_id        = "service/${aws_ecs_cluster.logstash_cluster.name}/${aws_ecs_service.logstash_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "ecs_policy" {
  name               = "logstash-scaling-policy"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    target_value       = 40.0
    scale_in_cooldown  = 60 # Wait before scaling in, e.g. removing tasks
    scale_out_cooldown = 60 # Wait before scaling out, e.g. adding tasks
  }
}

resource "aws_appautoscaling_policy" "ecs_memory_policy" {
  name               = "logstash-scaling-policy-memory"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }
    target_value       = 40.0 # Scale when memory utilization is above 75%
    scale_in_cooldown  = 60
    scale_out_cooldown = 60
  }
}
