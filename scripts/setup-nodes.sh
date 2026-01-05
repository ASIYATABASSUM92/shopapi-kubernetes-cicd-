#!/bin/bash

echo "======================================"
echo "🚀 ShopAPI Kubernetes Setup"
echo "======================================"
echo ""

# Check which node we're on
read -p "Which node is this? (1=Kubernetes, 2=Registry): " NODE_NUM

if [ "$NODE_NUM" == "1" ]; then
    echo "Setting up Node 1: Kubernetes Cluster"
    
    # Install K3d
    curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
    
    # Install kubectl
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    chmod +x kubectl
    mv kubectl /usr/local/bin/
    
    # Create cluster
    k3d cluster create shopapi \
      --servers 1 \
      --agents 2 \
      --port "8080:80@loadbalancer" \
      --port "30000-30010:30000-30010@server:0" \
      --wait
    
    # Create namespaces
    kubectl create namespace shopapi
    
    NODE_IP=$(hostname -i)
    echo "✅ Kubernetes ready at: $NODE_IP"
    echo "NODE1_IP=$NODE_IP" > ~/node-ips.txt
    
elif [ "$NODE_NUM" == "2" ]; then
    echo "Setting up Node 2: Docker Registry"
    
    # Run registry
    docker run -d \
      --name registry \
      -p 5000:5000 \
      -e REGISTRY_STORAGE_DELETE_ENABLED=true \
      registry:2
    
    NODE_IP=$(hostname -i)
    echo "✅ Registry ready at: $NODE_IP:5000"
    echo "NODE2_IP=$NODE_IP" > ~/node-ips.txt
    
else
    echo "Invalid node number!"
    exit 1
fi

echo ""
echo "======================================"
echo "✅ Setup complete!"
echo "======================================"
