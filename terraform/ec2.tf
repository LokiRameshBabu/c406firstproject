# ec2.tf

# Generate an SSH key pair
resource "tls_private_key" "my_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

# Create AWS key pair using the generated public key
resource "aws_key_pair" "generated_key" {
  key_name   = "${var.cohort_number}-key"  # Replace with your desired key name
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

# Read the docs -> https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
resource "aws_instance" "my_instance" {
  ami           = "ami-0ae8f15ae66fe8cda"
  instance_type = "t2.micro"  # Replace with your desired instance type

  associate_public_ip_address = true  # Enable public IPv4 and DNS hostname

  
  private_dns_name_options {
    hostname_type = "ip-name"
    enable_resource_name_dns_a_record = true
    enable_resource_name_dns_aaaa_record = false
  }

  key_name = aws_key_pair.generated_key.key_name

  vpc_security_group_ids = [aws_security_group.instance.id]

  root_block_device {
    volume_size = 8  # Set the volume size to 8GB
  }

  tags = {
    Name = var.cohort_number
  }
}
