output "AWS-AMI" {
  value = data.aws_ami.amzami.id
}

output "vpc_id" {
    value = aws_vpc.nginx_vpc.id
}

output "IGW" {
  value = aws_internet_gateway.nginx_igw.id
}

output "route-table" {
  value = aws_route_table.nginx_rtable.id
}

output "SG" {
  value = aws_security_group.nginx-ssh-sg.id
}

output "ec2-publicIP" {
  value = aws_instance.myapp-server.public_ip
}

output "ec2-url" {
  value = aws_instance.myapp-server.public_dns
}