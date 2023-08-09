data "aws_ami" "amazon-linux-2" {
 most_recent = true
 filter {
   name   = "owner-alias"
   values = ["amazon"]
 }
 filter {
   name   = "name"
   values = ["amzn2-ami-hvm*"]
 }
}

variable "profile" {
  type = string
  description = "AWS Profile"
}
variable "region" {
  type = string
  description = "AWS Region"
}
variable "domain" {
  type = string
  description = "Domain"
}