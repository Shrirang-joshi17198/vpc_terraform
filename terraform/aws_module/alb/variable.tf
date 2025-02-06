variable "alb_name" {
  description = "Name of the ALB"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for the ALB"
  type        = string
}

variable "subnets" {
  description = "List of subnet IDs"
  type        = list(string)
}

variable "internal" {
  description = "Whether the ALB is internal"
  type        = bool
  default     = false
}

variable "security_groups" {
  description = "Security groups associated with the ALB"
  type        = list(string)
}

variable "listeners" {
  description = "List of listener configurations"
  type = list(object({
    port            = number
    protocol        = string
    target_group_arn = string
  }))
}

variable "tags" {
  description = "Tags for the ALB"
  type        = map(string)
  default     = {}
}
