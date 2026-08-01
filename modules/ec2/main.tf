resource "aws_instance" "github_runner" {

  ami                    = var.ami_id
  instance_type          = var.instance_type

  subnet_id              = var.subnet_id

  vpc_security_group_ids = var.security_group_ids

  iam_instance_profile   = var.instance_profile

  key_name               = var.key_name

 user_data = templatefile("${path.module}/userdata.sh.tpl", {

  github_owner = var.github_owner
  github_repo  = var.github_repo
  github_pat   = var.github_pat

  runner_labels = var.runner_labels
})
  root_block_device {

    volume_size = 30

    volume_type = "gp3"

    encrypted = true
  }

  metadata_options {
    http_tokens = "required"
  }

  tags = {

    Name = "${var.project_name}-${var.environment}-github-runner"

    Environment = var.environment

    Terraform = "true"
  }
}