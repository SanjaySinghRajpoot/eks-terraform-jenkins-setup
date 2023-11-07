variable "vpc_cidr" {
  type        = string
  description = "CIDR for jenkins"
}

variable "public_subnets" {
    description = "Subnets CIDR"
    type = list(string)
}

variable "instance_type" {
    description = "ec2 instance type"
    type = string
}