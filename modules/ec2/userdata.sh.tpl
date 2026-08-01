#!/bin/bash
set -euxo pipefail

exec > >(tee /var/log/github-runner-install.log)
exec 2>&1
############################################
# System Update
############################################

dnf update -y --allowerasing

############################################
# Install Required Packages
############################################


dnf install -y --allowerasing \
git \
docker \
wget \
jq \
tar \
unzip \
yum-utils

############################################
# Enable Docker
############################################

systemctl enable docker
systemctl start docker

usermod -aG docker ec2-user

############################################
# Install AWS CLI v2
############################################

cd /tmp

curl -o awscliv2.zip \
https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip

unzip -q awscliv2.zip

./aws/install

############################################
# Install Terraform
############################################

yum-config-manager \
--add-repo \
https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo

dnf install -y terraform

############################################
# Install kubectl
############################################

curl -LO \
"https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

chmod +x kubectl

mv kubectl /usr/local/bin/

############################################
# Install Helm
############################################

curl -fsSL \
https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

############################################
# Install Trivy
############################################

rpm --import https://aquasecurity.github.io/trivy-repo/rpm/public.key

cat >/etc/yum.repos.d/trivy.repo <<EOF
[trivy]
name=Trivy Repository
baseurl=https://aquasecurity.github.io/trivy-repo/rpm/releases/\$basearch/
enabled=1
gpgcheck=1
gpgkey=https://aquasecurity.github.io/trivy-repo/rpm/public.key
EOF

dnf install -y trivy

############################################
# Create Runner User
############################################

id github-runner || useradd -m github-runner

mkdir -p /actions-runner

cd /actions-runner

############################################
# Download GitHub Runner
############################################

RUNNER_VERSION="2.328.0"

curl -L \
-o actions-runner.tar.gz \
https://github.com/actions/runner/releases/download/v$${RUNNER_VERSION}/actions-runner-linux-x64-$${RUNNER_VERSION}.tar.gz

tar xzf actions-runner.tar.gz

chown -R github-runner:github-runner /actions-runner
############################################
# Get Registration Token
############################################

REG_TOKEN=$(curl -s -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer ${github_pat}" \
  https://api.github.com/repos/${github_owner}/${github_repo}/actions/runners/registration-token \
  | jq -r '.token')

if [ -z "$REG_TOKEN" ] || [ "$REG_TOKEN" = "null" ]; then
    echo "ERROR: Failed to retrieve GitHub registration token"
    exit 1
fi

############################################
# Configure Runner
############################################

sudo -u github-runner ./config.sh \
    --url https://github.com/${github_owner}/${github_repo} \
    --token "$REG_TOKEN" \
    --labels "${runner_labels}" \
    --unattended \
    --replace

############################################
# Install Runner Service
############################################

./svc.sh install github-runner
./svc.sh start

############################################
# Verify
############################################

systemctl status actions.runner.* --no-pager || true

echo "GitHub Self-hosted Runner Installed Successfully"