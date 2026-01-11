locals {
  common_tags = {
    Name        = "${var.Environment}-${var.Project}"
    Environment = var.Environment
    Project     = var.Project
  }
  # ECS
  ecs_cluster_name = aws_ecs_cluster.main.name

  ecs_services = {
    frontend = aws_ecs_service.frontend.name
    backend  = aws_ecs_service.backend.name
  }

  # ALB ARN suffixes (required by CloudWatch)
  alb_arn_suffix = replace(
    aws_lb.app_alb.arn,
    "arn:aws:elasticloadbalancing:${var.region[0]}:${data.aws_caller_identity.current.account_id}:",
    ""
  )

  frontend_tg_arn_suffix = replace(
    aws_lb_target_group.frontend.arn,
    "arn:aws:elasticloadbalancing:${var.region[0]}:${data.aws_caller_identity.current.account_id}:",
    ""
  )

  backend_tg_arn_suffix = replace(
    aws_lb_target_group.backend.arn,
    "arn:aws:elasticloadbalancing:${var.region[0]}:${data.aws_caller_identity.current.account_id}:",
    ""
  )

}


