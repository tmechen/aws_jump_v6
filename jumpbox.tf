terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
  }
}
provider "aws" {
  profile    = var.profile
  region     = var.region
}

resource "aws_instance" "jumpbox" {
  ami                         = data.aws_ami.amazon-linux-2.id
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.subnet_jumpbox.id
  vpc_security_group_ids      = [aws_security_group.sg_jumpbox.id]
  source_dest_check           = false
  iam_instance_profile        = aws_iam_instance_profile.s3_access_for_ec2_instance_profile.name
  key_name                    = aws_key_pair.jump_key_pair.key_name
  associate_public_ip_address = false
  ipv6_address_count = 1
  root_block_device {
    volume_size           = 30
    volume_type           = "gp3"
    delete_on_termination = true
    encrypted             = true
  }
  tags = {
    "Name" = "jumpbox" 
  }
}

resource "tls_private_key" "jump_key_pair" {
  algorithm = "ED25519"
}
resource "aws_key_pair" "jump_key_pair" {
  key_name   = "jump_key_pair"  
  public_key = tls_private_key.jump_key_pair.public_key_openssh
}
