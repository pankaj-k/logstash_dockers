# Stage 3: Create the load balancer. You create of type internal=false. This means that
# this load balancer can take in traffic from the internet. And the instances it is 
# distrubuting the traffic to have public ip. Meaning that the clients from internet
# can initiate connections to those instances. Webservers usually run in the public subnet
# which this load balancer will serve. The security group of this loadbalancer is open to
# all incoming and outgoing traffic on port 80.

# ELB does health check using instance private IP. 

# Application load balancers (ALB) are region specific and can serve multiple availability zones 
# within that region. They cannot push traffic to another region.

resource "aws_lb" "aws_load_balancer" {
  name               = "aws-load-balancer"
  internal           = "false"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.load_balancer_security_group.id]
  # subnets needs a list of subnets
  #subnets = [aws_subnet.public_web_subnets.*.id]
  subnets = [aws_subnet.publicA.id, aws_subnet.publicB.id, aws_subnet.publicC.id]

  # Enable access logs for debugging. Strange that cloudwatch logs not there for ALBs
  access_logs {
    bucket  = aws_s3_bucket.logstash_ecs_lb_access_logs.id
    enabled = true
  }

  depends_on = [aws_s3_bucket_policy.alb_access_logs_policy]
}
