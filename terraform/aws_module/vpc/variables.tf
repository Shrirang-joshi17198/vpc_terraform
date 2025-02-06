variable "vpc_name" {
    type        = string
    description = "My_vpc"
}

variable "public_subnet_count" {
    type        = number
    description = "Number of public subnets"
    default     = 2
}

variable "private_subnet_count" {
    type        = number
    description = "Number of private subnets"
    default     = 2
}
variable "database_subnet_count" {
    type        = number
    description = "Number of database subnets"
    default     = 2
}
