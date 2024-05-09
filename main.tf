# AWS Provider
provider "aws" {
  region     = "us-west-2"
  access_key = "acces-key"  # llave de acceso
  secret_key = "secret-key" # llave secreta
}

# VPC
resource "aws_vpc" "parcial" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "parcial-vpc"
  }
}

# Subred1
resource "aws_subnet" "subnet1" {
  cidr_block        = "10.0.1.0/24"
  vpc_id            = aws_vpc.parcial.id
  availability_zone = "us-west-2a"
  tags = {
    Name = "subnet1"
  }
}

#Subred2
resource "aws_subnet" "subnet2" {
  cidr_block        = "10.0.2.0/24"
  vpc_id            = aws_vpc.parcial.id
  availability_zone = "us-west-2b"
  tags = {
    Name = "subnet2"
  }
}

#Internet Gateway
resource "aws_internet_gateway" "parcial" {
  tags = {
    Name = "parcial-igw"
  }
}

# Tabla de enrutamiento
resource "aws_route_table" "parcial" {
  vpc_id = aws_vpc.parcial.id
  tags = {
    Name = "parcial-rt"
  }
}

# Asociación de la tabla de enrutamiento con las subredes
resource "aws_route_table_association" "parcial" {
  route_table_id = aws_route_table.parcial.id
  subnet_id      = aws_subnet.subnet1.id
}

resource "aws_route_table_association" "parcial2" {
  route_table_id = aws_route_table.parcial.id
  subnet_id      = aws_subnet.subnet2.id
}

# Grupo de seguridad
resource "aws_security_group" "parcial" {
  name        = "parcial-sg"
  description = "parcial security group"
  vpc_id      = aws_vpc.parcial.id

 
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


# Creacion de instancias EC2
#Instancia 1
resource "aws_instance" "parcial" {
  ami                    = "ami-023e152801ee4846a" 
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.parcial.id]
  subnet_id              = aws_subnet.subnet1.id
  tags = {
    Name = "parcial-instance-1"
  }
}

# Instancia 2
resource "aws_instance" "parcial2" {
  ami                    = "ami-023e152801ee4846a"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.parcial.id]
  subnet_id              = aws_subnet.subnet2.id
  tags = {
    Name = "parcial-instance-2"
  }
}