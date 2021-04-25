## Security groups

# Web - EC2 Instance Security Group
resource "aws_security_group" "sec_web" {
  name        = "web-server-sg"
  description = "Allowing requests to the web servers"
  vpc_id      = module.vpc-webapp.vpc_id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.sec_alb.id]
  }

  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.sec_alb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = local.tags
}
#  Bastion host security group : allow ssh and ICMP ping from allowed external subnets
resource "aws_security_group" "sec_bastion" {
  name   = "bastion-sg"
  vpc_id = module.vpc-webapp.vpc_id

  ingress {
    description = "SSH from specific addresses"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.cidr_allowed_external
  }
  ingress {
    description = "Ping from specific addresses"
    from_port   = 8 # ICMP Code 8 - echo  (0 is echo reply)
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = var.cidr_allowed_external
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = local.tags
}

#   Internal instances - allow ping, ssh and web from bastion
resource "aws_security_group" "sec_internal_mgmt" {
  name   = "internal-mgmt-sg"
  vpc_id = module.vpc-webapp.vpc_id

  ingress {
    description     = "SSH from bastion host(s)"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.sec_bastion.id]
  }

  ingress {
    description     = "Ping from bastion host(s)"
    from_port       = 8 # ICMP Code 8 - echo  (0 is echo reply)
    to_port         = 0
    protocol        = "icmp"
    security_groups = [aws_security_group.sec_bastion.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = local.tags
}

# Web - ALB Security Group
resource "aws_security_group" "sec_alb" {
  name        = "alb-sg"
  description = "Allowing HTTP/HTTPS requests to the application load balancer"
  vpc_id      = module.vpc-webapp.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(local.tags, {
    Name = "alb-sg"
  })
}