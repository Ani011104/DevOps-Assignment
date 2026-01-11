resource "aws_sns_topic" "alerts" {
  name = "${var.Environment}-${var.Project}-alerts"
}

resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email
}

resource "aws_cloudwatch_metric_alarm" "ecs_cpu_high" {
  for_each = local.ecs_services

  alarm_name          = "${each.key}-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 5
  threshold           = 70

  metric_name = "CPUUtilization"
  namespace   = "AWS/ECS"
  period      = 60
  statistic   = "Average"

  dimensions = {
    ClusterName = local.ecs_cluster_name
    ServiceName = each.value
  }

  alarm_actions = [aws_sns_topic.alerts.arn]
}


resource "aws_cloudwatch_dashboard" "ecs_dashboard" {
  dashboard_name = "${var.Environment}-${var.Project}-dashboard"

  dashboard_body = jsonencode({
    widgets = [

      # Frontend CPU
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6
        properties = {
          region = var.region[0]
          view   = "timeSeries"
          metrics = [
            ["AWS/ECS", "CPUUtilization", "ClusterName", local.ecs_cluster_name, "ServiceName", local.ecs_services.frontend]
          ]
          stat   = "Average"
          period = 60
          title  = "Frontend CPU"
        }
      },

      # Backend CPU
      {
        type   = "metric"
        x      = 12
        y      = 0
        width  = 12
        height = 6
        properties = {
          region = var.region[0]
          view   = "timeSeries"
          metrics = [
            ["AWS/ECS", "CPUUtilization", "ClusterName", local.ecs_cluster_name, "ServiceName", local.ecs_services.backend]
          ]
          stat   = "Average"
          period = 60
          title  = "Backend CPU"
        }
      },

      # ALB Request Count
      {
        type   = "metric"
        x      = 0
        y      = 6
        width  = 12
        height = 6
        properties = {
          region = var.region[0]
          view   = "timeSeries"
          metrics = [
            ["AWS/ApplicationELB", "RequestCount", "LoadBalancer", local.alb_arn_suffix]
          ]
          stat   = "Sum"
          period = 60
          title  = "ALB Request Count"
        }
      },

      # Backend Latency
      {
        type   = "metric"
        x      = 12
        y      = 6
        width  = 12
        height = 6
        properties = {
          region = var.region[0]
          view   = "timeSeries"
          metrics = [
            ["AWS/ApplicationELB", "TargetResponseTime", "TargetGroup", local.backend_tg_arn_suffix]
          ]
          stat   = "Average"
          period = 60
          title  = "Backend Latency"
        }
      }
    ]
  })
}

