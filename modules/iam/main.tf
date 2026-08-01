resource "aws_iam_role" "runner" {

  name = "${var.project_name}-${var.environment}-runner-role"

  assume_role_policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {

        Effect = "Allow"

        Principal = {

          Service = "ec2.amazonaws.com"

        }

        Action = "sts:AssumeRole"

      }

    ]

  })
}


resource "aws_iam_instance_profile" "runner" {

  name = "${var.project_name}-${var.environment}-runner-profile"

  role = aws_iam_role.runner.name
}

