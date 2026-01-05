#!/bin/bash

echo "======================================"
echo "🚀 Deploying to Kubernetes"
echo "======================================"
echo ""

# Get registry IP
read -p "Enter Registry IP (Node 2 IP): " REGISTRY_IP

# Update backend.yaml with registry IP
echo "Updating backend deployment with registry IP..."
sed -i "s/REGISTRY_IP/$REGISTRY_IP/g" kubernetes/02-backend.yaml

# Deploy to Kubernetes
echo "Deploying database..."
kubectl apply -f kubernetes/01-database.yaml

echo "Waiting 30 seconds for database..."
sleep 30

echo "Deploying backend..."
kubectl apply -f kubernetes/02-backend.yaml

echo "Waiting 20 seconds for backend..."
sleep 20

echo "Deploying frontend..."
kubectl apply -f kubernetes/03-frontend.yaml

echo ""
echo "======================================"
echo "📊 Checking deployment status..."
echo "======================================"
echo ""

kubectl get pods -n shopapi
echo ""
kubectl get services -n shopapi

echo ""
echo "======================================"
echo "✅ Deployment complete!"
echo "======================================"
echo ""
echo "🌐 Access your application:"
echo "   - Click the '8080' button in Play with Docker"
echo "   - Or visit: http://<NODE1_IP>:8080"
echo ""
```

---

### **10. .gitignore**
```
node_modules/
*.log
.DS_Store
.env
*.swp
*.swo
*~
