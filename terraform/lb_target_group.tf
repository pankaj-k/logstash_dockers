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
}
