terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region  = "eu-central-1"
}
variable "subnets" {
  type    = list(string)
  default = ["10.10.1.0/24", "10.10.2.0/24"]
}
data "aws_availability_zones" "azs" {
  state = "available"
}


resource "aws_vpc" "my_vpc" {
  cidr_block = "10.10.0.0/16"
  enable_dns_hostnames = true
}

resource "aws_subnet" "subnet_az" {
  count = 2
  cidr_block        = var.subnets[count.index]
  vpc_id            = aws_vpc.my_vpc.id
  availability_zone = data.aws_availability_zones.azs.names[count.index]
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my_vpc.id
}
resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.my_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "test_rt"
  }
}

resource "aws_route_table_association" "az1_rt" {
  count = 2
  subnet_id      = aws_subnet.subnet_az[count.index].id
  route_table_id = aws_route_table.rt.id
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "wordpress_db_sg"
  subnet_ids = [aws_subnet.subnet_az[0].id, aws_subnet.subnet_az[1].id]
  tags = {
    Name = "My DB subnet group"
  }
}

resource "aws_elb" "aws_classic_elb" {
  name               = "test-elb"
  security_groups = [aws_security_group.elb.id]
  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }
  subnets = [aws_subnet.subnet_az[0].id, aws_subnet.subnet_az[1].id]
  instances                   = [aws_instance.wordpress_server1.id, aws_instance.wordpress_server2.id]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name = "foobar-terraform-elb"
  }
  depends_on = [aws_instance.wordpress_server1, aws_instance.wordpress_server2]
}



output "elb_address" {
  value = aws_elb.aws_classic_elb.dns_name
}