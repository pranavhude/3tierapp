#!/bin/bash
set -e

echo "Updating system"
sudo yum update -y

#################################
# Install Git
#################################
echo "Installing Git"
sudo yum install -y git
git --version

#################################
# Install Java 17 (for Jenkins)
#################################
echo "Installing Java 17"
sudo amazon-linux-extras enable java-openjdk17
sudo yum install -y java-17-openjdk
java -version

#################################
# Install Jenkins
#################################
echo "Installing Jenkins"
sudo wget -O /etc/yum.repos.d/jenkins.repo \
  https://pkg.jenkins.io/redhat-stable/jenkins.repo

sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

sudo yum install -y jenkins
sudo systemctl enable jenkins
sudo systemctl start jenkins
sudo systemctl status jenkins --no-pager

#################################
# Install Docker
#################################
echo "Installing Docker"
sudo yum install -y docker
sudo systemctl enable docker
sudo systemctl start docker
sudo systemctl status docker --no-pager

sudo usermod -aG docker ec2-user
sudo usermod -aG docker jenkins

#################################
# Install AWS CLI v2
#################################
echo "Installing AWS CLI v2"
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o awscliv2.zip
sudo yum install -y unzip
unzip awscliv2.zip
sudo ./aws/install
aws --version

#################################
# Install kubectl
#################################
echo "Installing kubectl"
curl -LO https://dl.k8s.io/release/v1.28.4/bin/linux/amd64/kubectl
chmod +x kubectl
sudo mv kubectl /usr/local/bin/
kubectl version --client

#################################
# Install eksctl
#################################
echo "Installing eksctl"
curl -sL "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_Linux_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin
eksctl version

#################################
# Install Terraform
#################################
echo "Installing Terraform"
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
sudo yum install -y terraform
terraform -version

#################################
# Install Helm
#################################
echo "Installing Helm"
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
helm version

#################################
# Final verification summary
#################################
echo "===== TOOL VERSIONS ====="
git --version
java -version
jenkins --version || true
docker --version
aws --version
kubectl version --client
eksctl version
terraform -version
helm version
