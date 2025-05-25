resource "aws_cloudwatch_log_group" "main" {
  name = "${var.project_name}-ecs-logs"
  retention_in_days = 7
  
  tags = {
    Name    = "${var.project_name}-ecs-logs"
    Project = var.project_name
  }
}
