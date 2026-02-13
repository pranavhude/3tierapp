#!/bin/bash
set -e

sudo yum update -y

sudo yum install -y git
git --version


sudo yum install -y docker
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker ec2-user

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o awscliv2.zip
sudo yum install -y unzip
unzip awscliv2.zip
sudo ./aws/install
aws --version


curl -LO https://dl.k8s.io/release/v1.29.0/bin/linux/amd64/kubectl
chmod +x kubectl
sudo mv kubectl /usr/local/bin/


curl -sL https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_Linux_amd64.tar.gz | tar xz
sudo mv eksctl /usr/local/bin


sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
sudo yum install -y terraform


curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

echo "===== TOOL VERSIONS ====="
git --version
docker --version
aws --version
kubectl version --client
eksctl version
terraform -version
helm version

