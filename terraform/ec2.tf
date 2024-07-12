# ec2.tf

# Generate an SSH key pair
resource "tls_private_key" "my_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

# Create AWS key pair using the generated public key
resource "aws_key_pair" "generated_key" {
  key_name   = "c500-key"  # Replace with your desired key name
  public_key = tls_private_key.my_key.public_key_openssh
}


resource "aws_security_group" "instance" {
  name_prefix = "instance-sg-"
  description = "Security group for instance"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

    ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Get the latest Amazon Linux 2023 AMI that supports t2.micro
data "aws_ami" "amazon_linux_2023" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn-ami-al2023-*-hvm-*"]  # Use Amazon Linux 2023 AMIs that are HVM
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"]  # Amazon's owner ID for Amazon Linux AMIs
}

# Read the docs -> https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
resource "aws_instance" "my_instance" {
  ami           = data.aws_ami.amazon_linux_2023.value
  instance_type = "t2.micro"  # Replace with your desired instance type

  key_name = aws_key_pair.generated_key.key_name

  vpc_security_group_ids = [aws_security_group.instance.id]

  tags = {
    Name = "c500"  # Replace with your Cohort Number
  }
}
