# configure aws provider

provider "aws" {
  access_key = ""   # place access keys here
  secret_key = ""   # place secret key here
  region = "us-east-1"
  #profile = "Admin"
}

# create instance

resource "aws_instance" "web_server02" {
  ami           = "ami-053b0d53c279acc90" # us-east-1
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.web_ssh.id]
  # subnet_id     = aws_subnet.my_pub_subnet.id*

  user_data = "${file("install_jenkins.sh")}"

    tags = {
    "Name": "tf_made_instance"
  }
}

#configure vpc

resource "aws_vpc" "project_vpc" {
  cidr_block = "" # enter your cidr_block here

  tags = {
    Name = "project-vpc"
  }
}

#configure subnet

resource "aws_subnet" "my_pub_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "" # enter your cidr_block here
  availability_zone = "us-east-1a"

  tags = {
    Name = "project-subnet-public1-us-east-1a"
  }
}

# create security groups

resource "aws_security_group" "web_ssh" {
  name = "tf_made_sg2"
  description = "open ssh traffic"


  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" : "tf_made_sg2"
  }

}

output "instance_ip" {
  value = aws_instance.web_server02.public_ip
}
