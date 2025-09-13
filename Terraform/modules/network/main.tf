resource "aws_vpc" "winterEcommvpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

   tags = merge(local.common_tags, {
    Name = "${var.project_name}-vpc"
  })
}

# PUBLIC SUBNET 1
resource "aws_subnet" "public" {
  for_each   = var.public_subnets  
  vpc_id     = aws_vpc.ecsvpc.id
  cidr_block = each.value
  availability_zone = local.public_subnets_with_az[each.key]
  map_public_ip_on_launch = true

   tags = merge(local.common_tags, {
    Name = "${var.project_name}-${each.key}"
    Type = "public"
  })
}

# PRIVATE SUBNET
resource "aws_subnet" "private" {
  for_each   = var.private_subnets
  vpc_id     = aws_vpc.ecsvpc.id
  cidr_block = each.value
  availability_zone = local.private_subnets_with_az[each.key]
  map_public_ip_on_launch = false

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-${each.key}"
    Type = "private"
  })
}

# INTERNET GATEWAY
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.ecsvpc.id

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-igw"
  })
}

# Elastic IP for NAT Gateway
resource "aws_eip" "nat_eip" {

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-nat-eip"
  })
}

# NAT Gateway in the first public subnet
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = values(aws_subnet.public)[0].id   # Pick the first public subnet
  tags = merge(local.common_tags, {
    Name = "${var.project_name}-nat-gw"
  })

  depends_on = [aws_internet_gateway.igw]
}

# PUBLIC ROUTE TABLE 
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.ecsvpc.id

  route {
    cidr_block = var.allow_cidrs[0]
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-public-rt"
  })
}

# PUBLIC ROUTE TABLE ASSOCIATION
resource "aws_route_table_association" "public_rt_association" {
  for_each       = aws_subnet.public  
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id

  
}


# PRIVATE ROUTE TABLE
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.ecsvpc.id
  route {
    cidr_block     = var.allow_cidrs[0]
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-private-rt"
  })
}

# PRIVATE ROUTE TABLE ASSOCIATION
resource "aws_route_table_association" "private_rt_association" {
  for_each       = aws_subnet.private  
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private.id


}

# PUBLIC NACL
resource "aws_network_acl" "public" {
  vpc_id = aws_vpc.ecsvpc.id

  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = var.allow_cidrs[0]
    from_port  = 0
    to_port    = 0
  }

  ingress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = var.allow_cidrs[0]
    from_port  = 0
    to_port    = 0
  }

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-public-nacl"
  })
  }

  resource "aws_network_acl_association" "public" {
  for_each      = aws_subnet.public
  network_acl_id = aws_network_acl.public.id
  subnet_id      = each.value.id
}


# PRIVATE NACL
resource "aws_network_acl" "private" {
  vpc_id = aws_vpc.ecsvpc.id

  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = var.allow_cidrs[0]
    from_port  = 0
    to_port    = 0
  }

  ingress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = var.vpc_cidr
    from_port  = 0
    to_port    = 0
  }

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-private-nacl"
  })
}

# PRIVATE NACL ASSOCIATION
resource "aws_network_acl_association" "private_nacl_association" {
  for_each       = aws_subnet.private
  network_acl_id = aws_network_acl.private.id
  subnet_id      = each.value.id
}

# PUBLIC SECURITY GROUP
resource "aws_security_group" "public_sg" {
  name        = "${var.project_name}-public-sg"
  description = "Allow web server traffic + ssh traffic"
  vpc_id      = aws_vpc.ecsvpc.id

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-public-sg"
  })
}

# Ingress rules
resource "aws_vpc_security_group_ingress_rule" "ingress" {

  for_each = var.public_sg_ingress
  security_group_id = aws_security_group.public_sg.id
  cidr_ipv4         = var.allow_cidrs[0]
  from_port         = each.value.from
  to_port           = each.value.to
  ip_protocol       = each.value.protocol
}

# Egress (all traffic)
resource "aws_vpc_security_group_egress_rule" "all" {
  security_group_id = aws_security_group.public_sg.id
  cidr_ipv4         = var.allow_cidrs[0]
  ip_protocol       = "-1"
}