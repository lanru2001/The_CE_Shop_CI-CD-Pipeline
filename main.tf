
resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = file(var.PATH_TO_PUBLIC_KEY)
}


resource "aws_vpc" "prod-vpc" {
  cidr_block       = var.vpc-cidr  # Check how to dynamically set cidr_block 

  tags = {
    Name = "prod-vpc"
  }
}

resource "aws_subnet" "private-subnets" {
  vpc_id = aws_vpc.prod-vpc.id
  count = length(var.azs)
  cidr_block = element(var.private-subnets , count.index)

  tags = {
    Name = "private-subnet-${count.index+1}"
  }
}

resource "aws_subnet" "public-subnets" {
  vpc_id = aws_vpc.prod-vpc.id
  count = length(var.azs)
  cidr_block = element(var.public-subnets , count.index)

  tags = {
    Name = "public-subnet-${count.index+1}"
  }
}

#IGW
resource "aws_internet_gateway" "prod-igw" {
  vpc_id = aws_vpc.prod-vpc.id

  tags = {
    Name = "prod-igw"
  }
}

#route table for public subnet
resource "aws_route_table" "public-rtable" {
  vpc_id = aws_vpc.prod-vpc.id

  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.prod-igw.id
  }

  tags = {
    Name = "prod-public-rtable"
  }

  depends_on = [aws_internet_gateway.prod-igw]
}



#route table association public subnets
resource "aws_route_table_association" "public-subnet-association" {
  count          = length(var.public-subnets)
  subnet_id      = element(aws_subnet.public-subnets.*.id , count.index)
  route_table_id = aws_route_table.public-rtable.id
}

resource "aws_instance" "webserver" {
  ami             = var.AMI
  instance_type   = var.instance_type
  key_name        = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [ "${aws_security_group.instance.id}" ]
  user_data       = file("userdata.sh")
  lifecycle {
    create_before_destroy = true
  }
  tags = {
    Name = "web_server"
  }
  provisioner "file" {
    source      = "index.html"
    destination = "/tmp/index.html"
    connection {
      host = aws_instance.webserver.public_ip
      type     = "ssh"
      user     = "ec2-user"
      private_key =  file(var.PATH_TO_PRIVATE_KEY)
      timeout = "2m"
    }
  }

}

resource "aws_security_group" "instance" {
  name = "test-sg"
  description = "Allow traffic for instances"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 65535
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
}

