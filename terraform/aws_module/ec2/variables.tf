variable "ami_id" {
  type        = string
  description = "AMI ID for the EC2 instance"
}

variable "instance_type" {
  type        = string
  description = "Type of EC2 instance"
  default     = "t2.micro"
}

variable "subnet_id" {
  type        = string
  description = "Subnet ID to launch the EC2 instance in"
}

variable "security_group_id" {
  type        = string
  description = "Security group for the EC2 instance"
}

variable "key_name" {
  type        = string
  description = "Key pair for SSH access"
}

variable "instance_name" {
  type        = string
  description = "Name of the EC2 instance"
}
