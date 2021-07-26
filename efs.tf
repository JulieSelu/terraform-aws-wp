resource "aws_efs_file_system" "efs" {
  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }
  tags = {
    Name = "MyTestEFS"
  }
}

resource "aws_efs_mount_target" "efs_to_az" {
  count = 2
  file_system_id = aws_efs_file_system.efs.id
  subnet_id      = aws_subnet.subnet_az[count.index].id
  security_groups = [aws_security_group.efs.id]
}
//output "efs_mp" {
//  value = aws_efs_file_system.efs.dns_name
//}