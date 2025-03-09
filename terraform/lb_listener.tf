# The aws_lb_listener resource specifies how to handle any HTTP requests to loadbalancer on port 80. 
# In this case, it forwards all requests to the load balancer to a target group. 

resource "aws_lb_listener" "aws_load_balancer_listener" {
  load_balancer_arn = aws_lb.aws_load_balancer.arn
  port              = "80" # Incoming traffic to load balancer on port 80.
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.aws_load_balancer_target_group.arn
  }
}
