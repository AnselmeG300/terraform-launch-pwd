output "instance_id" {
  value = aws_instance.app_pwd.id
}

output "instance_public_ip" {
  value = aws_instance.app_pwd.public_ip
}