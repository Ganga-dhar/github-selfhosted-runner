#########################
# VPC
##########################


module "vpc" {

  source = "../../../modules/vpc"

  project_name = var.project_name

  environment = var.environment

  vpc_cidr = var.vpc_cidr

  availability_zones = var.availability_zones

  public_subnets = var.public_subnets

  private_subnets = var.private_subnets
}

#########################
# EC2
##########################

module "github_runner" {

  source = "../../../modules/ec2"

  project_name = "platform"
  environment  = "dev"

  ami_id = data.aws_ami.amazon_linux.id

  subnet_id = module.vpc.private_subnet_ids[0]

  security_group_ids = [
    module.sg.security_group_id
  ]

  instance_profile = module.iam.instance_profile_name

  github_owner = var.github_owner
  github_repo  = var.github_repo
  github_pat   = var.github_pat

  runner_labels = var.runner_labels
}

module "sg" {

  source = "../../../modules/sg"

  project_name = var.project_name

  environment = var.environment

  vpc_id = module.vpc.vpc_id

  allowed_ssh_cidr = [
    "203.0.113.10/32"
  ]
}

module "iam" {

  source = "../../../modules/iam"

  project_name = var.project_name

  environment = var.environment

}