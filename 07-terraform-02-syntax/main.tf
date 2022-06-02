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

resource "aws_instance" "test" {
  ami           = data.aws_ami.ubuntu-linux-2004.id
  instance_type = "${terraform.workspace == "stage" ? "t3.nano" : "t3.micro"}"
  count         = "${terraform.workspace == "stage" ? "1" : "2"}"
  availability_zone = "us-west-2b"
  subnet_id     = "subnet-5d7c8e17"

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "count"
  }
}


resource "aws_instance" "test_1" {
  ami           = data.aws_ami.ubuntu-linux-2004.id
  instance_type = "${terraform.workspace == "stage" ? "t3.nano" : "t3.micro"}"
  availability_zone = "us-west-2b"
  subnet_id     = "subnet-5d7c8e17"
  for_each      = toset(local.virtual_machines)
  tags = {
    Name = "each-${each.key}"
  }
}