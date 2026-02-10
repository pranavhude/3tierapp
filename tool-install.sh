#!/bin/bash
set -e

echo "Updating system"
sudo dnf update -y

#################################
# Install Git
#################################
echo "Installing Git"
sudo dnf install -y git
git --version

#################################
# Install Java 17 (for Jenkins)
#################################
echo "Installing Java 17"
sudo dnf install -y java-17-amazon-corretto
java -version

#################################
# Install Jenkins
#################################
echo "Installing Jenkins"
sudo wget -O /etc/yum.repos.d/jenkins.repo \
  https://pkg.jenkins.io/redhat-stable/jenkins.repo

sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

sudo dnf install -y jenkins
sudo systemctl enable jenkins
sudo systemctl start jenkins

#################################
# Install Docker
#################################
echo "Installing Docker"
sudo dnf install -y docker docker-compose-plugin
sudo systemctl enable docker
sudo systemctl start docker

sudo usermod -aG docker ec2-user
sudo usermod -aG docker jenkins

#################################
# Install AWS CLI v2
#################################
echo "Installing AWS CLI v2"
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o awscliv2.zip
sudo dnf install -y unzip
unzip -o awscliv2.zip
sudo ./aws/install --update
aws --version

#################################
# Install kubectl (latest stable)
#################################
echo "Installing kubectl"
KUBECTL_VERSION=$(curl -Ls https://dl.k8s.io/release/stable.txt)
curl -LO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/
kubectl version --client

#################################
# Install eksctl
#################################
echo "Installing eksctl"
curl -sL "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_Linux_amd64.tar.gz" \
  | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin
eksctl version

#################################
# Install Terraform
#################################
echo "Installing Terraform"
sudo dnf install -y yum-utils
sudo yum-config-manager --add-repo \
  https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
sudo dnf install -y terraform
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
echo "==============================="
echo "      TOOL VERSIONS"
echo "==============================="
git --version
java -version
jenkins --version || echo "Jenkins CLI not available"
docker --version
docker compose version
aws --version
kubectl version --client
eksctl version
terraform -version
helm version
