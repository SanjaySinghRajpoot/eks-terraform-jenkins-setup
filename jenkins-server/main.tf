# VPC group 

# This module will automatically create route tables and route table associations for us
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc"
  cidr = var.vpc_cidr

  azs             = data.aws_availability_zones.azs.names
#   private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = var.public_subnets

  enable_dns_hostnames = true

  tags = {
    Name = "jenkins-vpc"
    Terraform = "true"
    Environment = "dev"
  }

  public_subnet_tags = {
    Name = "jenkins-subnet"
  }
}


# SG

module "sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "jenkins-sg"
  description = "sg for jenkins"
  vpc_id      = module.vpc.vpc_id

  # ingress_cidr_blocks      = ["10.10.0.0/16"]
  # ingress_rules            = ["https-443-tcp"]
  ingress_with_cidr_blocks = [
    {
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      description = "HTTP"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "SSH"
      cidr_blocks = "0.0.0.0/0"
    },
  ]

  egress_with_cidr_blocks = [
    {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  tags = {
    Name = "jenkins-sg"

  }
}




# EC2
module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "jenkins-ec2-instance"

  instance_type          = var.instance_type

  ## need to add the key_name here 45:00 
  key_name               = "jenkins-ec2"
  monitoring             = true
  vpc_security_group_ids = [module.sg.security_group_id]
  subnet_id              = module.vpc.public_subnets[0]
  associate_public_ip_address = true
  user_data = file("jenkins-install.sh")
  availability_zone = data.aws_availability_zones.azs.names[0]

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}