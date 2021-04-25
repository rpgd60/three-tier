# Auxiliary variable for resource tags 
variable "resource_tags" {
  description = "Tags to set for all resources"
  type        = map(string)
  default     = {} ## Empty on purpose -- will be populated in a locals definition in main.tf
}

# General Variables
variable "aws_region" {
  description = "The AWS region where Terraform deploys your instance"
  type        = string
  default     = "eu-west-1"
}

variable "aws_credentials_profile" {
  description = "The profile used to connect to AWS - from .aws/credentials"
  type        = string
  default     = "tfadmin1"
}

# EC2 Instance related variables
variable "ec2_instance_type" {
  type        = string
  description = "Instance type to use"
  # default = "t2.micro"
}

variable "ec2_key_name" {
  type        = string
  description = "Key to connect to instance with ssh"
}

## used only if bastion is deployed
variable "bastion_key_name" {
  type        = string
  description = "Key to connect to bastion hosts with ssh"
}

## CIDR blocks from which to allow ssh and ping into instances (if used)
variable "cidr_allowed_external" {
  description = "List of CIDR blocks that are considered whitelisted for ICMP and SSH access to bastion host"
  type        = list(string)
}

# Tagging and naming
variable "project_name" {
  type        = string
  description = "project name - typically used as prefix to name some resources"
}

variable "project_env" {
  type        = string
  description = "project environment - typically inserted as suffix in some resource names"
}

# VPC Variables


variable "public_subnets" {
  type        = list(string)
  description = "list of subnets used in vpc module for public subnets"
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "private_subnets" {
  type        = list(string)
  description = "list of subnets used in vpc module for private subnets"
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "database_subnets" {
  type        = list(string)
  description = "list of subnets used in vpc module for database subnets"
  default     = ["10.0.201.0/24", "10.0.202.0/24"]
}

locals {
  azs = ["${var.aws_region}a", "${var.aws_region}b"]
}
