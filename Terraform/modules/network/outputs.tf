output "public_subnet_ids" {
  value = [for s in aws_subnet.public : s.id]
}

output "vpc_id" {
  value = aws_vpc.ecsvpc.id
}

output "public_sg_id" {
  value = aws_security_group.public_sg.id
}
