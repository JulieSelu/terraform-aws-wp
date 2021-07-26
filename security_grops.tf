resource "aws_security_group" "servers" {
  name        = "servers_rules"
  description = "This is a security group for web servers"
  vpc_id      = aws_vpc.my_vpc.id
  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    protocol    = "icmp"
    from_port   = -1
    to_port     = -1
    cidr_blocks = ["0.0.0.0/0"] #[aws_vpc.my_vpc.cidr_block]
  }
  ingress {
    description = "EFS mount target"
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_security_group" "mysql" {
  name        = "db_rules"
  description = "managed by terrafrom for db servers"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    protocol  = "tcp"
    from_port = 3306
    to_port   = 3306
    security_groups = [aws_security_group.servers.id]
  }

  egress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_security_group" "efs" {
  name        = "efs_access"
  description = "This is a security group for efs access"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    protocol    = "tcp"
    from_port   = 0
    to_port     = 2049
    cidr_blocks = [aws_vpc.my_vpc.cidr_block]
  }
}

resource "aws_security_group" "elb" {
  name        = "elb_rules"
  description = "This is a security group for web servers"
  vpc_id      = aws_vpc.my_vpc.id
  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}