variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "ami_id" {
  type = string
}

variable "instance_type" {
  type = string
  default = "t3.medium"
}

variable "subnet_id" {
  type = string
}

variable "security_group_ids" {
  type = list(string)
}

variable "instance_profile" {
  type = string
}

variable "key_name" {
  type = string
  default = null
}


variable "runner_labels" {
  type = string
  default = "self-hosted,linux,docker"
}

variable "github_owner" {
  type = string
}

variable "github_repo" {
  type = string
}

variable "github_pat" {
  type      = string
  sensitive = true
}

variable "runner_labels" {
  type    = string
  default = "self-hosted,ec2"
}