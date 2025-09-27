variable "alb_name" {
  description = "Prefix name for ALB resources"
  type        = string
}

variable "env" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "security_group_id" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "target_port" {
  type        = number
  description = "Port traffic should be routed to in the ECS task"
}

variable "health_check_path" {
  type        = string
  description = "Path for ALB health checks"
}

variable "alb_internal" {
  description = "Whether the load balancer is internal"
  type        = bool
  default     = false
}

variable "alb_deletion_protection" {
  description = "Whether to enable deletion protection on the ALB"
  type        = bool
  default     = false
}

variable "target_group_name" {
  description = "Name of the target group"
  type        = string
}

variable "listener_port" {
  description = "Port the ALB listener will listen on"
  type        = number
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

variable "certificate_arn" {
  description = "The ARN of the ACM certificate"
  type        = string
}

variable "ssl_policy" {
  default = "ELBSecurityPolicy-2016-08"
}