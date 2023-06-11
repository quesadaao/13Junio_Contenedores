variable "access_key" {
  type = string
  default = "AKIATU5KIZXM3XUSM53Q" 
}

variable "secret_key" {
  type = string
  default = "hSK3Z0GQSloH9rbNnzp9CDy9OJw4tyxB2qj4vd9/"
}

variable "region" {
  type = string
  default = "us-east-1"
  description = "region to deploy"
}

variable "availability_zone_a" {
  type = string
  description = "availability_zone_a"
}

variable "availability_zone_b" {
  type = string
  description = "availability_zone_b"
}

variable "instance_type" {
  type = string
  default = "t2.micro"  
  description = "type of the instance to deploy"
}

variable "security_group" {
  type = string
  default = "sg-0d8623f518af5d129"  
}

variable "public_key" {
  type = string
  default = ""  
  description = "public_key to do login"
}

variable "private_key" {
  type = string  
  description = "private_key to do login"
}

variable "aws_vpc_cidr" {
  default = "10.20.20.0/26"
  description = "Mean Stack VPC CIDR"
}

variable "project_name" {
  type = string  
  description = "mean"
}

variable "password_mongo" {
  type = string  
  description = "password de mongo db"
}

variable "created_by" {
  type = string  
  description = "User who create this project"
}

