# Configure AWS provider
provider "aws" {
  access_key = ""
  secret_key = ""
  region     = "us-east-1"
}

# Create an EC2 instance with Jenkins installed
resource "aws_instance" "web_server01" {
  ami           = "ami-053b0d53c279acc90"
  instance_type = "t2.micro"
  subnet_id     = "subnet-07eaa879b5e96a6b6"  

  user_data = <<-EOF
    #!/bin/bash
    # Update and install necessary packages
    sudo yum update -y
    sudo yum install -y java-1.8.0-openjdk-devel

    # Install Jenkins from a GitHub repo
    sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
    sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
    sudo yum install -y jenkins

    # Start Jenkins and enable it to start on boot
    sudo systemctl start jenkins
    sudo systemctl enable jenkins
    EOF

  key_name = "YOUR_KEY_PAIR_NAME_HERE"  # Replace with your EC2 key pair name

  tags = {
    "Name": "tf_made_instance"
  }
}

# Output the public IP address of the EC2 instance
output "instance_ip" {
  value = aws_instance.web_server01.public_ip
}


# Configure VPC
#resource "aws_vpc" "main" {
  #cidr_block = "0.0.0.0/16"  # Replace with your VPC's CIDR block
#vpc_id = vpc-073ade3ebea048f2c

  #tags = {
    #Name = ""
  }
}

# Create a security group
resource "aws_security_group" "web_ssh" {
  name        = "tf_made_sg2"
  description = "open SSH and Jenkins traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name": "tf_made_sg2"
  }
}
