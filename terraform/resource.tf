resource "aws_vpc" "nginx_vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    "Name" : "vpc-qa-project1"
  }
}

resource "aws_subnet" "nginx_subnet" {
  vpc_id = aws_vpc.nginx_vpc.id
  depends_on = [ aws_vpc.nginx_vpc ]
  availability_zone = var.aws_availzone
  cidr_block = var.subnet_cidr
  tags = {
    "Name" : "nginx-vpc-subnet"
  }
}

resource "aws_internet_gateway" "nginx_igw" {
  vpc_id = aws_vpc.nginx_vpc.id
  depends_on = [ aws_vpc.nginx_vpc ]
  tags = {
    "Name" : "nginx-igw"
  }
}

resource "aws_route_table" "nginx_rtable" {
  vpc_id = aws_vpc.nginx_vpc.id
  depends_on = [ aws_internet_gateway.nginx_igw]
  tags = {
    "Name" : "nginx-route-table"
  }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.nginx_igw.id
  }
}

resource "aws_route_table_association" "nginx_associate_subnet" {
  subnet_id = aws_subnet.nginx_subnet.id
  route_table_id = aws_route_table.nginx_rtable.id
}

resource "aws_security_group" "nginx-ssh-sg" {
  description = "security group to allow ssh on port-80"
  depends_on = [ aws_route_table.nginx_rtable ]
  vpc_id = aws_vpc.nginx_vpc.id
  ingress {
    from_port = var.ssh_port
    to_port = var.ssh_port
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

   ingress {
    from_port = var.nginx_port
    to_port = var.nginx_port
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

   egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    prefix_list_ids = []
  }
  tags = {
    "Name" : "nginx-ssh-sg"
  }
}

resource "aws_instance" "myapp-server" {
  ami = data.aws_ami.amzami.id
  instance_type = var.instance_type
  availability_zone = var.aws_availzone
  key_name = "testkey"
  subnet_id = aws_subnet.nginx_subnet.id
  vpc_security_group_ids = [aws_security_group.nginx-ssh-sg.id]
  associate_public_ip_address = true
  user_data = file("startup.sh")
   
  tags = {
    "Name" : "App-Server"
  }
}
