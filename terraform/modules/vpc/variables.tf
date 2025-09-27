variable "region" {
  description = "AWS region to deploy resources in"
  type        = string
  default     = "eu-west-1"
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "env" {}
variable "vpc-name" {}
variable "igw-name" {}
variable "public-rt-name" {}
variable "private-rt-name" {}
variable "public_sub_name" {}
variable "private_sub_name" {}
variable "eip-name" {}
variable "ngw-name" {}

variable "public_subnet_count" {
  description = "Number of public subnets to create"
  type        = number
  default     = 2
}

variable "private-subnet-count" {
  description = "Number of private subnets to create"
  type        = number
  default     = 2
}
