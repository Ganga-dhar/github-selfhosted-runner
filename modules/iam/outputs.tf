output "instance_profile_name" {

  value = aws_iam_instance_profile.runner.name

}

output "role_name" {

  value = aws_iam_role.runner.name

}

output "role_arn" {

  value = aws_iam_role.runner.arn

}