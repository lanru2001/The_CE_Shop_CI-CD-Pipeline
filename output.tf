output "public_ip" {
  value = aws_instance.webserver.public_dns
}

output "vpc_id" {
  value = aws_vpc.app-vpc.id
}

output "instance_ips" {
  value = aws_instance.webserver.*.public_ip
}

output "subnet_id" {
  value = aws_instance.webserver.subnet_id
}

