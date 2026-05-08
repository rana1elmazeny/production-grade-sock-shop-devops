resource "aws_vpc" "sockshop_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "sockshop-dev-vpc"
    Project     = "SockShop"
    Environment = "Dev"
  }
}

resource "aws_subnet" "public_subnets" {
  count = length(var.public_subnet_cidrs)

  vpc_id                  = aws_vpc.sockshop_vpc.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name        = "sockshop-public-subnet-${count.index + 1}"
    Project     = "SockShop"
    Environment = "Dev"
    Type        = "Public"
  }
}

resource "aws_subnet" "private_subnets" {
  count = length(var.private_subnet_cidrs)

  vpc_id            = aws_vpc.sockshop_vpc.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name        = "sockshop-private-subnet-${count.index + 1}"
    Project     = "SockShop"
    Environment = "Dev"
    Type        = "Private"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.sockshop_vpc.id

  tags = {
    Name        = "sockshop-dev-igw"
    Project     = "SockShop"
    Environment = "Dev"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.sockshop_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name        = "sockshop-public-route-table"
    Project     = "SockShop"
    Environment = "Dev"
  }
}

resource "aws_route_table_association" "public_subnet_association" {
  count = length(aws_subnet.public_subnets)

  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_rt.id
}
resource "aws_security_group" "bastion_sg" {
  name        = "sockshop-bastion-sg"
  description = "Allow SSH access to Bastion"
  vpc_id      = aws_vpc.sockshop_vpc.id

  ingress {
    description = "SSH from my IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "sockshop-bastion-sg"
    Project     = "SockShop"
    Environment = "Dev"
  }
}

resource "aws_security_group" "sonarqube_sg" {
  name        = "sockshop-sonarqube-sg"
  description = "Allow SSH and SonarQube access"
  vpc_id      = aws_vpc.sockshop_vpc.id

  ingress {
    description = "SSH from my IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  ingress {
    description = "SonarQube UI"
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "sockshop-sonarqube-sg"
    Project     = "SockShop"
    Environment = "Dev"
  }
}

resource "aws_instance" "bastion" {
  ami                         = var.ami_id
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.public_subnets[0].id
  vpc_security_group_ids      = [aws_security_group.bastion_sg.id]
  key_name                    = var.key_name
  associate_public_ip_address = true

  tags = {
    Name        = "sockshop-bastion"
    Project     = "SockShop"
    Environment = "Dev"
    Role        = "Bastion"
  }
}


resource "aws_instance" "sonarqube" {
  ami                         = var.ami_id
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.public_subnets[1].id
  vpc_security_group_ids      = [aws_security_group.sonarqube_sg.id]
  key_name                    = var.key_name
  associate_public_ip_address = true

  tags = {
    Name        = "sockshop-sonarqube"
    Project     = "SockShop"
    Environment = "Dev"
    Role        = "SonarQube"
  }
}
