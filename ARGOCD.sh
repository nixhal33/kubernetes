#!/bin/bash

# 1. Install Argo CD Components
echo "Creating namespace and installing Argo CD..."
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# 2. Configure Networking (Expose via NodePort)
echo "Patching service to NodePort..."
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "NodePort"}}'[cite: 1]

# 3. Download and Install Argo CD CLI
echo "Downloading Argo CD CLI..."
curl -sSL -o argocd https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64[cite: 1]
chmod +x argocd[cite: 1]
sudo mv argocd /usr/local/bin/[cite: 1]

# 4. Wait for the secret to be generated and retrieve password
echo "Waiting for initial admin secret..."
sleep 5
ARGOCD_PWD=$(kubectl get secret -n argocd argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)[cite: 1]

echo "---------------------------------------------------"
echo "Argo CD Installation Complete!"
echo "Your initial admin password is: $ARGOCD_PWD"[cite: 1]
echo "---------------------------------------------------"
echo "To login via CLI, use:"
echo "argocd login <EXTERNAL_IP>:<NODE_PORT> --username admin --password $ARGOCD_PWD --insecure"[cite: 1]
