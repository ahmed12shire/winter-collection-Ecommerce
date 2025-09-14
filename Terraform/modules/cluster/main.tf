resource "aws_ecs_cluster" "cluster" {
  name = "${var.project_name}-cluster"
}

resource "aws_ecs_task_definition" "task" {
  family                   = var.project_name
  network_mode             = "bridge"  # Using EC2 instances
  requires_compatibilities = ["EC2"]
  cpu                      = "256"
  memory                   = "256"
  execution_role_arn       = var.ecs_execution_role_arn
  task_role_arn            = var.ecs_task_role_arn

  container_definitions = jsonencode([{
    name      = "ecs-container"
    image     = "${var.ecr_repository_url}:${var.image_tag}"
    essential = true
    portMappings = [{
      containerPort = 80
      hostPort      = 0
      protocol      = "tcp"
    }]
  }])

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-task"
  })
}

resource "aws_ecs_service" "ecs_service" {
  name            = "${var.project_name}-service"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.task.arn
  desired_count   = 2
  launch_type     = "EC2"  # Running on EC2 instances
  

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "ecs-container"
    container_port   = 80
  }


}
