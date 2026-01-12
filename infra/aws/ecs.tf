/* 
for ecs fragate , i will need to create 
-cluster - which will logical contain all the services / resources for ecs
-task defintion - which will define the container and its properties (2 for this project)
-task - actually container ( one for frontend and one for backend)
-service - will keep the required number of tasks running (2 for this project)
- lanuch type , network , alb connection to the tasks ( place this inside the target group )    
*/


# ECS Cluster
resource "aws_ecs_cluster" "main" {
  name = "${var.Environment}-${var.Project}-cluster"
}

# Security Group for ECS Tasks
resource "aws_security_group" "ecs_sg" {
  name   = "${var.Environment}-${var.Project}-ecs-sg"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port       = 3000
    to_port         = 3000
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  ingress {
    from_port       = 8000
    to_port         = 8000
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.common_tags
}

# Backend Task Definition
resource "aws_ecs_task_definition" "backend" {
  family                   = "${var.Project}-backend"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = var.ecs_execution_role_arn

  container_definitions = jsonencode([
    {
      name  = "backend"
      image = var.backend_image
      portMappings = [
        {
          containerPort = 8000
          protocol      = "tcp"
        }
      ]
    }
  ])
}

# Frontend Task Definition
resource "aws_ecs_task_definition" "frontend" {
  family                   = "${var.Project}-frontend"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = var.ecs_execution_role_arn

  container_definitions = jsonencode([
    {
      name  = "frontend"
      image = var.frontend_image
      portMappings = [
        {
          containerPort = 3000
          protocol      = "tcp"
        }
      ]
    }
  ])
}

# Backend ECS Service
resource "aws_ecs_service" "backend" {
  name            = "${var.Project}-backend"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.backend.arn
  desired_count   = 2
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = [aws_subnet.private_a.id, aws_subnet.private_b.id]
    security_groups = [aws_security_group.ecs_sg.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.backend.arn
    container_name   = "backend"
    container_port   = 8000
  }

  depends_on = [aws_lb_listener.http]
}


# Frontend ECS Service

resource "aws_ecs_service" "frontend" {
  name            = "${var.Project}-frontend"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.frontend.arn
  desired_count   = 2
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = [aws_subnet.private_a.id, aws_subnet.private_b.id]
    security_groups = [aws_security_group.ecs_sg.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.frontend.arn
    container_name   = "frontend"
    container_port   = 3000
  }

  depends_on = [aws_lb_listener.http]
}
