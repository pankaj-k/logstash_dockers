resource "aws_ecs_cluster" "logstash_cluster" {
  name = "logstash_ecs_fargate_cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = {
    Name = "logstash_ecs_fargate_cluster"
  }
}

resource "aws_ecs_task_definition" "logstash_task" {
  family                   = "logstash-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 1024
  memory                   = 2048
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

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
    }
  ])

  tags = {
    Name = "logstash-task"
  }
}

resource "aws_ecs_service" "logstash_service" {
  name            = "logstash-service"
  cluster         = aws_ecs_cluster.logstash_cluster.id
  task_definition = aws_ecs_task_definition.logstash_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [aws_subnet.publicA.id, aws_subnet.publicB.id, aws_subnet.publicC.id]
    security_groups  = [aws_security_group.logstash_sg.id]
    assign_public_ip = true
  }

  tags = {
    Name = "logstash-service"
  }
}
