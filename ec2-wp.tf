data "template_file" "phpconfig" {
  template = file("wp-config.php")

  vars = {
    db_port = 3306
    db_host = aws_db_instance.mysql.endpoint
    db_user = var.username
    db_pass = var.password
    db_name = var.dbname
  }
  depends_on = [aws_db_instance.mysql]
}

data "template_file" "setup1" {
  template = file("setup_first_instance.sh")
  vars = {
    db_port = 3306
    db_host = aws_db_instance.mysql.endpoint
    db_user = var.username
    db_pass = var.password
    db_name = var.dbname
    efs_dns_name = aws_efs_file_system.efs.dns_name
  }
  depends_on = [aws_efs_file_system.efs]
}
data "template_file" "setup2" {
  template = file("setup_instance.sh")
  vars = {
    efs_dns_name = aws_efs_file_system.efs.dns_name
  }
  depends_on = [aws_efs_file_system.efs]
}
data "aws_ami" "amazon_linux" {
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = [137112412989] #amazon
}

resource "aws_db_instance" "mysql" {
  engine               = "mysql"
  engine_version       = "8.0.23"
  name                 = var.dbname
  username             = var.username
  password             = var.password
  instance_class       = "db.t2.micro"
  storage_type         = "gp2"
  allocated_storage    = 10
  max_allocated_storage = 100
  db_subnet_group_name = aws_db_subnet_group.db_subnet_group.id
  publicly_accessible  = false
  vpc_security_group_ids = [aws_security_group.mysql.id]
  parameter_group_name = "default.mysql8.0"
  port = 3306
  skip_final_snapshot  = true
  auto_minor_version_upgrade = true
}

resource "aws_instance" "wordpress_server1" {
  ami                         = data.aws_ami.amazon_linux.id
  subnet_id                   = aws_subnet.subnet_az[0].id
  instance_type               = "t2.micro"
  availability_zone           = data.aws_availability_zones.azs.names[0]
  vpc_security_group_ids      = [aws_security_group.servers.id]
  associate_public_ip_address = true
  key_name                    = var.ssh_key_name
  user_data = data.template_file.setup1.rendered
  provisioner "file" {
    content     = data.template_file.phpconfig.rendered
    destination = "/tmp/wp-config.php"
    connection {
      type        = "ssh"
      user        = "ec2-user"
      host        = self.public_ip
      private_key = file(var.ssh_priv_key)
    }
  }
  tags = {
    Name = "HelloWorld"
  }
  depends_on = [aws_efs_file_system.efs]
}
resource "aws_instance" "wordpress_server2" {
  ami                         = data.aws_ami.amazon_linux.id
  subnet_id                   = aws_subnet.subnet_az[1].id
  instance_type               = "t2.micro"
  availability_zone           = data.aws_availability_zones.azs.names[1]
  vpc_security_group_ids      = [aws_security_group.servers.id]
  associate_public_ip_address = true
  key_name                    = var.ssh_key_name
  user_data = data.template_file.setup2.rendered
  tags = {
    Name = "HelloWorld"
  }
  depends_on = [aws_efs_file_system.efs]
}

output "instance_ip_addr1" {
  value = aws_instance.wordpress_server1.public_ip
}

output "instance_ip_addr2" {
  value = aws_instance.wordpress_server2.public_ip
}
