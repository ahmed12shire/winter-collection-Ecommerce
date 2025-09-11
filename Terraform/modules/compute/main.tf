

resource "aws_instance" "ecsproject" {
  count         = var.instance_count
  ami           = local.instance_ami
  instance_type = var.instance_type
  subnet_id     = element(var.subnet_id, count.index % length(var.subnet_id))
  vpc_security_group_ids = var.vpc_security_group_ids
  user_data     = var.ecs_user_data

  # iam_instance_role = var.ecs_instance_role_name
  iam_instance_profile = var.ecs_instance_profile_name


  
  tags = merge(
    var.tags,
    { Name = "${var.tags.Project}-instance-${count.index + 1}" }
  )
}