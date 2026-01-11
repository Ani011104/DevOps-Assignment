/*
FOR an application load balancer , here are the requriments
-must have 2 az , and 2 public subnets in it -- done
-must have sg created for the alb , for this project , we have 80 tcp - http to be allowed
-internet facing
-must have 2 target greoups
-listener rules , where frontend port is 3000 and backend port is 8000
*/
resource "aws_security_group" "alb_sg" {
  name        = "${var.Environment}-${var.Project}-alb-sg"
  description = "ALB security group"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.common_tags
}

#Creatting alb , internet facing
resource "aws_lb" "app_alb" {
  name               = "${var.Environment}-${var.Project}-alb"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets = [
    aws_subnet.public_a.id,
    aws_subnet.public_b.id
  ]

  tags = local.common_tags
}

#Creating target group for frontend , tg can be for ip , ec2 , lamba we choose ip for ecs
resource "aws_lb_target_group" "frontend" {
  name        = "${var.Environment}-${var.Project}-frontend-tg"
  port        = 3000
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "ip"

  health_check {
    path = "/"
  }

  tags = local.common_tags
}

#Creating target group for backend
resource "aws_lb_target_group" "backend" {
  name        = "${var.Environment}-${var.Project}-backend-tg"
  port        = 8000
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "ip"

  health_check {
    path = "/api/health"
  }

  tags = local.common_tags
}

#ALB Listener
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend.arn
  }
}

#Listener Rule for Backend API
resource "aws_lb_listener_rule" "backend" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 10

  condition {
    path_pattern {
      values = ["/api/*"]
    }
  }
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend.arn
  }
}
