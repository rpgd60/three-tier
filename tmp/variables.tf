# General Variables

variable "aws_region" {
  description = "The AWS region where Terraform deploys your instance"
  default     = "eu-west-1"
}

variable "aws_credentials_profile" {
  description = "The profile used by TF to connect to AWS - from .aws/credentials"
  default     = "tfadmin1"
}

# EC2 Instance related variables
variable "ec2_instance_type" {
  type    = string
  description = "Instance type to use"
  # default = "t2.micro"
}

variable "ec2_key_name" {
  type        = string
  description = "Key to connect to instance with ssh"
  # Note no default - variable must be supplied via CLI, Environment variables or .tfvars file
}


