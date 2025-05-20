resource "aws_db_instance" "main" {
  allocated_storage      = 20
  port                   = 5432
  storage_type           = "gp2"
  publicly_accessible    = false
  db_name                = "postgres"
  engine                 = "postgres"
  engine_version         = "17.2"
  instance_class         = "db.t4g.micro"
  username               = var.db_username
  password               = var.db_password
  skip_final_snapshot    = true
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.main.id]
  multi_az               = false

  tags = {
    Name    = "${var.project_name}-db"
    Project = var.project_name
  }
}

output "db_instance_endpoint" {
  value = aws_db_instance.main.endpoint
}
