variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "public_subnet_ids" {
  description = "The IDs of the public subnets"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "The IDs of the private subnets"
  type        = list(string)
}

variable "db_username" {
  description = "The database admin account username"
  type        = string
}

variable "db_password" {
  description = "The database admin account password"
  type        = string
  sensitive   = true
}

variable "key_name" {
  description = "The name of the EC2 Key Pair"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}
