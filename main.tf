# Configure AWS provider
provider "aws" {
  access_key = "YOUR_ACCESS_KEY_HERE"
  secret_key = "YOUR_SECRET_KEY_HERE"
  region     = "us-east-1"
}

# Create an EC2 instance with Jenkins installation script from a GitHub repo
resource "aws_instance" "jenkins_instance" {
  ami           = "ami-053b0d53c279acc90"
  instance_type = "t2.micro"
  subnet_id     = "YOUR_SUBNET_ID_HERE"  # Replace with the ID of the existing public subnet in your VPC

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
output "jenkins_instance_public_ip" {
  value = aws_instance.jenkins_instance.public_ip
}


# Configure VPC
resource "aws_vpc" "project_vpc" {
  cidr_block = "YOUR_VPC_CIDR_BLOCK_HERE"  # Replace with your VPC's CIDR block

  tags = {
    Name = "project-vpc"
  }
}

# Configure subnet
resource "aws_subnet" "my_pub_subnet" {
  vpc_id            = aws_vpc.project_vpc.id
  cidr_block        = "YOUR_SUBNET_CIDR_BLOCK_HERE"  # Replace with your subnet's CIDR block
  availability_zone = "us-east-1a"

  tags = {
    Name = "project-subnet-public1-us-east-1a"
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
