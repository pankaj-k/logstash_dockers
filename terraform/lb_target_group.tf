# Target group defines the collection of instances your load balancer sends traffic to. 
# It does not manage the configuration of the targets in that group directly, 
# but instead specifies a list of destinations the load balancer can forward requests to.

# Here the loadbalancer forwards requests to the target group which is configured to send
# traffic to the logstash container running on port 5044.

resource "aws_lb_target_group" "aws_load_balancer_target_group" {
  name        = "aws-lb-target-group"
  port        = "5044" # Logstash container listens on port 5044. Target Group should be configured with port 5044 to send traffic to Logstash.
  protocol    = "HTTP"
  target_type = "ip" # Needed for ECS. 
  vpc_id      = aws_vpc.main.id

  health_check {
    interval = 60  # Default is 30 seconds.
    timeout  = 30  # Default is 5 seconds.
    path     = "/" # If your app serves traffic at / then you can use this path. Otherwise, you can specify the path here. 
    # For example, if your app has a /health endpoint then set path = "/health"
  }
}

# Task is stopping
# Task failed ELB health checks in 
# (target-group arn:aws:elasticloadbalancing:us-east-1:875792031575:targetgroup/aws-lb-target-group/2b48cbeac328fac3)
# This usually happens when the ECS tasks take longer to become healthy than the ELB health check timeout allows.
