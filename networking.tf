resource "aws_vpc" "vpc_jumpbox" {
  cidr_block                       = "10.0.0.0/16"
  assign_generated_ipv6_cidr_block = true
  instance_tenancy                 = "default"
  enable_dns_support               = true
  enable_dns_hostnames             = true
}
resource "aws_subnet" "subnet_jumpbox" {
  vpc_id                          = aws_vpc.vpc_jumpbox.id
  availability_zone               = "eu-central-1c"
  cidr_block                      = cidrsubnet(aws_vpc.vpc_jumpbox.cidr_block, 4, 1)
  ipv6_cidr_block                 = cidrsubnet(aws_vpc.vpc_jumpbox.ipv6_cidr_block, 8, 1)
  assign_ipv6_address_on_creation = true
}

resource "aws_internet_gateway" "gateway_jumpbox" {
  vpc_id = aws_vpc.vpc_jumpbox.id
}
resource "aws_route_table" "routing_jumpbox" {
  vpc_id = aws_vpc.vpc_jumpbox.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gateway_jumpbox.id
  }
  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.gateway_jumpbox.id
  }
}
resource "aws_route_table_association" "routing_association" {
  subnet_id      = aws_subnet.subnet_jumpbox.id
  route_table_id = aws_route_table.routing_jumpbox.id
}

resource "aws_security_group" "sg_jumpbox" {
  depends_on = [aws_subnet.subnet_jumpbox]
  name       = "sg_jumpbox"
  vpc_id     = aws_vpc.vpc_jumpbox.id
  ingress {
    description      = "ssh"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    ipv6_cidr_blocks = ["::/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    ipv6_cidr_blocks = ["::/0"]
  }
}
