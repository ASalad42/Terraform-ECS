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

variable "env" {
  description = "Environment name"
  type        = string
  default     = "test"
}
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
variable "hosted_zone_id" {
  description = "Route53 hosted zone ID to create DNS records for"
  type        = string
}

variable "record_name" {
  description = "DNS record name (e.g., frontend.example.com)"
  type        = string
}

variable "record_type" {
  description = "Type of DNS record to create (usually A or CNAME)"
  type        = string
}

variable "https_listener_port" {
  description = "The port for the HTTPS listener"
  type        = number
  default     = 443
}

variable "https_listener_protocol" {
  description = "The protocol for the HTTPS listener"
  type        = string
  default     = "HTTPS"
}

variable "ssl_policy" {
  default = "ELBSecurityPolicy-2016-08"
}

variable "cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
}

variable "service_name" {
  description = "Name of the ECS service"
  type        = string
}

variable "desired_count" {
  description = "Number of desired ECS tasks"
  type        = number
}

variable "cluster_insight_name" {
  description = "name of the cluster setting name"
  type        = string
}

variable "cluster_insight_value" {
  description = "name of the cluster setting value"
  type        = string
}

variable "container_name" {
  description = "name of the container"
  type        = string
}

variable "container_port" {
  description = "container port"
  type        = number
}

variable "task_family" {
  description = "family name"
  type        = string
}

variable "task_cpu" {
  description = "cpu"
  type        = string
}

variable "task_memory" {
  description = "memory"
  type        = string
}

variable "image_url" {
  description = "link of the image in ecr"
  type        = string
}

variable "alb_sg_name" {
  type = string
}
variable "alb_sg_description" {
  type = string
}

variable "alb_ingress_http_from_port" {
  type = number
}
variable "alb_ingress_http_to_port" {
  type = number
}

variable "alb_ingress_cidr_blocks" {
  type        = list(string)
  description = "CIDR blocks allowed to access the ALB"
}

variable "alb_ingress_https_from_port" {
  type = number
}
variable "alb_ingress_https_to_port" {
  type = number
}

variable "ecs_egress_cidr_blocks" {
  type        = list(string)
  description = "CIDR blocks ECS tasks can access"
}

variable "ecs_sg_name" {
  type = string
}
variable "ecs_sg_description" {
  type = string
}
variable "ecs_ingress_from_port" {
  type = number
}
variable "ecs_ingress_to_port" {
  type = number
}
variable "ecs_egress_from_port" {
  type = number
}
variable "ecs_egress_to_port" {
  type = number
}
variable "ingress_protocol" {
  type = string
}
variable "egress_protocol" {
  type = string
}
variable "alb_name" {}
variable "alb_internal" {
  type    = bool
  default = false
}
variable "alb_deletion_protection" {
  type    = bool
  default = false
}

variable "target_group_name" {}
variable "target_group_protocol" {
  default = "HTTP"
}

variable "health_check_path" {
  default = "/"
}
variable "health_check_interval" {
  default = 30
}
variable "health_check_timeout" {
  default = 5
}
variable "health_check_healthy_threshold" {
  default = 2
}
variable "health_check_unhealthy_threshold" {
  default = 2
}
variable "health_check_matcher" {
  default = "200"
}

variable "listener_port" {
  default = 80
}
variable "listener_protocol" {
  default = "HTTP"
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
}


variable "domain_name" {
  description = "Domain name for Route53 record"
  type        = string

}