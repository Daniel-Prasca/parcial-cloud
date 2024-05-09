# Configure the AWS provider
provider "aws" {
  region     = "us-west-2"
  access_key = "acces-key"  # llave de acceso
  secret_key = "secret-key" # llave secreta
}

# Create a VPC
resource "aws_vpc" "parcial" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "parcial-vpc"
  }
}

# Create two subnets
resource "aws_subnet" "subnet1" {
  cidr_block        = "10.0.1.0/24"
  vpc_id            = aws_vpc.parcial.id
  availability_zone = "us-west-2a"
  tags = {
    Name = "subnet1"
  }
}

resource "aws_subnet" "subnet2" {
  cidr_block        = "10.0.2.0/24"
  vpc_id            = aws_vpc.parcial.id
  availability_zone = "us-west-2b"
  tags = {
    Name = "subnet2"
  }
}

# Create an Internet Gateway
resource "aws_internet_gateway" "parcial" {
  tags = {
    Name = "parcial-igw"
  }
}

# Create a route table
resource "aws_route_table" "parcial" {
  vpc_id = aws_vpc.parcial.id
  tags = {
    Name = "parcial-rt"
  }
}

# Associate the route table with the subnets
resource "aws_route_table_association" "parcial" {
  route_table_id = aws_route_table.parcial.id
  subnet_id      = aws_subnet.subnet1.id
}

resource "aws_route_table_association" "parcial2" {
  route_table_id = aws_route_table.parcial.id
  subnet_id      = aws_subnet.subnet2.id
}

# Create an EC2 instance
resource "aws_instance" "parcial" {
  ami                    = "ami-023e152801ee4846a" // Replace with your desired AMI
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.parcial.id]
  subnet_id              = aws_subnet.subnet1.id
  tags = {
    Name = "parcial-instance-1"
  }
}

# Create an EC2 instance 2
resource "aws_instance" "parcial2" {
  ami                    = "ami-023e152801ee4846a" // Replace with your desired AMI
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.parcial.id]
  subnet_id              = aws_subnet.subnet2.id
  tags = {
    Name = "parcial-instance-2"
  }
}

# Create a security group
resource "aws_security_group" "parcial" {
  name        = "parcial-sg"
  description = "parcial security group"
  vpc_id      = aws_vpc.parcial.id

  # Allow inbound traffic on port 22
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
#terraform init
#terraform apply 
#terraform apply -destroy