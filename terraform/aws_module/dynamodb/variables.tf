variable "table_name" {
  description = "The name of the DynamoDB table for Terraform state locking"
  type        = string
}

variable "environment" {
  description = "The environment for tagging (e.g., dev, prod)"
  type        = string
  default     = "dev"
}
