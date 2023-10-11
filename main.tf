# based on https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance

# configure aws provider
provider "aws" {
  access_key = var.access_key
  secret_key = var.secret_key
  region = var.region
  #profile = "Admin"
}

# create instance

resource "aws_instance" "web_server01" {
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  key_name = var.key_name
  associate_public_ip_address = true
  user_data = "${file("deploy.sh")}"

    tags = {
    "Name": var.tags
  }
}

# output new instance IP
output "instance_ip" {
  value = aws_instance.web_server01.public_ip
}
