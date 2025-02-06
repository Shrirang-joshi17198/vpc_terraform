variable "table_name" {
  description = "The name of the DynamoDB table for Terraform state locking."
  type        = string
}

variable "environment" {
  description = "The environment for the DynamoDB table."
  type        = string
}

