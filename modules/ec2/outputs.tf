output "instance_id" {
  value = aws_instance.github_runner.id
}

output "private_ip" {
  value = aws_instance.github_runner.private_ip
}

output "public_ip" {
  value = aws_instance.github_runner.public_ip
}