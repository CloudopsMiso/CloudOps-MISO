resource "aws_ecs_cluster" "main" {
  name = "${var.project_name}-ecs-cluster"

  tags = {
    Name    = "${var.project_name}-ecs-cluster"
    Project = var.project_name
  }
}

resource "aws_ecs_cluster_capacity_providers" "main" {
  cluster_name       = aws_ecs_cluster.main.name
  capacity_providers = ["FARGATE"]
}

resource "aws_ecs_task_definition" "main" {
  family                   = "${var.project_name}-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "1024"
  memory                   = "3072"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  

  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }

  container_definitions = jsonencode([
    {
      name      = "${var.project_name}-container"
      image     = "${aws_ecr_repository.main.repository_url}:latest"
      essential = true
      environment = [
        {
          name  = "DB_HOST"
          value = aws_db_instance.main.address
        },
        {
          name  = "DB_NAME"
          value = aws_db_instance.main.db_name
        },
        {
          name  = "DB_PASSWORD"
          value = var.db_password
        },
        {
          name  = "DB_USER"
          value = var.db_username
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.main.name
          "awslogs-region"       = "us-east-1"
          "awslogs-stream-prefix" = "ecs"
        }
      }
      portMappings = [
        {
          name = "${var.project_name}-port-8000"
          appProtocol   = "http"
          containerPort = 8000
          hostPort      = 8000
          protocol      = "tcp"
        }
      ]
    }
  ])

  tags = {
    Name    = "${var.project_name}-task"
    Project = var.project_name
  }
}

resource "aws_ecs_service" "main" {
  name            = "${var.project_name}-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.main.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  scheduling_strategy = "REPLICA"
  enable_ecs_managed_tags = true
  availability_zone_rebalancing = "ENABLED"

  network_configuration {
    subnets          = [aws_subnet.main.id, aws_subnet.main_2.id]
    security_groups  = [aws_security_group.main.id]
    assign_public_ip = true
  }

  deployment_controller {
    type = "CODE_DEPLOY"
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.main.arn
    container_name   = "${var.project_name}-container"
    container_port   = 8000
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.main_2.arn
    container_name   = "${var.project_name}-container"
    container_port   = 8000
  }

  tags = {
    Name    = "${var.project_name}-service"
    Project = var.project_name
  }
}