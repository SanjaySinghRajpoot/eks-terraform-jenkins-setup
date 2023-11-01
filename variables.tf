variable "vpc_cidr" {
  type        = string
  description = "CIDR for jenkins"
}

variable "public_subnets" {
    description = "Subnets CIDR"
    type = list(string)
}