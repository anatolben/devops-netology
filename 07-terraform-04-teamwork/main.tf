locals {
 virtual_machines = "${terraform.workspace == "stage" ? ["vm1"] : ["vm1", "vm2"] }"
}

provider "aws" {
  region = "us-west-2"
}

data "aws_ami" "ubuntu-linux-2004" {
  most_recent = true
  owners      = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  ami                    = data.aws_ami.ubuntu-linux-2004.id
  instance_type          = "${terraform.workspace == "stage" ? "t3.nano" : "t3.micro"}"
  key_name               = "test-ec2"
  monitoring             = true
  vpc_security_group_ids = ["sg-5d7c8e17"]
  subnet_id              = "subnet-5d7c8e17"
  for_each               = toset(local.virtual_machines)
  name                   = "instance-${each.key}"
  tags = {
    Name = "each"
  }
}