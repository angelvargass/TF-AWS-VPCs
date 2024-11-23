variable "instance_type" {
  type = string
  description = "EC2 instace type to be used"
}

variable "vpc_name" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "private_rt_name" {
  type = string
  description = "Name for the private route table"
}

variable "public_rt_name" {
  type = string
  description = "Name for the public route table"
}

variable "public_subnets_cidr" {
  type = list(string)
}

variable "private_subnets_cidr" {
  type = list(string)
}
