resource "aws_ecr_repository" "main" {
  name                 = var.project_name
  image_tag_mutability = "MUTABLE"

  tags = {
    Name    = "${var.project_name}-repo"
    Project = var.project_name
  }
}

output "docker_repository_url" {
  value = aws_ecr_repository.main.repository_url
}