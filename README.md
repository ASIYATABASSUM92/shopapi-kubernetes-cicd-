# 🛒 ShopAPI - Kubernetes CI/CD Demo Project

A full-stack e-commerce API demonstrating DevOps practices with Kubernetes, Docker, and CI/CD pipelines.

## 📋 Project Overview

This project showcases a production-ready deployment of a microservices application on Kubernetes:

- **Backend**: Node.js REST API with Express
- **Database**: PostgreSQL with persistent storage
- **Frontend**: Responsive web UI with Nginx
- **Infrastructure**: Kubernetes (K3d) with multi-node setup
- **CI/CD**: Automated build and deployment pipeline

## 🏗️ Architecture
```
┌─────────────────────────────────────────────────────────┐
│                  Kubernetes Cluster                      │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐             │
│  │ Frontend │◄─│ Backend  │◄─│PostgreSQL│             │
│  │  (Nginx) │  │(Node.js) │  │  (DB)    │             │
│  └──────────┘  └──────────┘  └──────────┘             │
└─────────────────────────────────────────────────────────┘
```

## 🚀 Quick Start (Play with Docker)

### Prerequisites
- Access to [Play with Docker](https://labs.play-with-docker.com/)
- GitHub account to host this repository

### Step 1: Setup Kubernetes Node

**Create Node 1** and run:
```bash
# Install K3d and kubectl
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl && mv kubectl /usr/local/bin/

# Create K3d cluster
k3d cluster create shopapi \
  --servers 1 \
  --agents 2 \
  --port "8080:80@loadbalancer" \
  --wait

# Create namespace
kubectl create namespace shopapi

# Save Node 1 IP
echo "NODE1_IP=$(hostname -i)"
```

### Step 2: Setup Docker Registry Node

**Create Node 2** and run:
```bash
# Run Docker Registry
docker run -d \
  --name registry \
  -p 5000:5000 \
  registry:2

# Save Node 2 IP
echo "NODE2_IP=$(hostname -i)"
```

### Step 3: Clone and Build

**On Node 2:**
```bash
# Install git
apk add git

# Clone repository (replace with your GitHub URL)
git clone https://github.com/YOUR_USERNAME/shopapi-kubernetes-cicd.git
cd shopapi-kubernetes-cicd

# Build backend image
cd backend
docker build -t $(hostname -i):5000/shopapi-backend:latest .

# Push to registry
docker push $(hostname -i):5000/shopapi-backend:latest
```

### Step 4: Deploy to Kubernetes

**On Node 1:**
```bash
# Clone repository
apk add git
git clone https://github.com/YOUR_USERNAME/shopapi-kubernetes-cicd.git
cd shopapi-kubernetes-cicd

# Update backend YAML with registry IP
# Replace REGISTRY_IP with Node 2 IP (e.g., 192.168.0.22)
sed -i 's/REGISTRY_IP/192.168.0.22/g' kubernetes/02-backend.yaml

# Deploy all components
kubectl apply -f kubernetes/01-database.yaml
sleep 30
kubectl apply -f kubernetes/02-backend.yaml
sleep 20
kubectl apply -f kubernetes/03-frontend.yaml

# Check status
kubectl get pods -n shopapi
kubectl get services -n shopapi
```

### Step 5: Access Application

Click the **"8080"** button at the top of Node 1 in Play with Docker!

## 📦 What's Included

### Backend API Endpoints

- `GET /health` - Health check
- `GET /api/products` - List all products
- `POST /api/products` - Create product
- `PUT /api/products/:id` - Update product
- `DELETE /api/products/:id` - Delete product

### Sample Data

The database is pre-populated with 10 products:
- Laptop ($999.99)
- Wireless Mouse ($29.99)
- Mechanical Keyboard ($79.99)
- And 7 more products...

## 🛠️ Tech Stack

| Component | Technology |
|-----------|-----------|
| **Backend** | Node.js + Express |
| **Database** | PostgreSQL 15 |
| **Frontend** | HTML5 + JavaScript |
| **Web Server** | Nginx Alpine |
| **Container** | Docker |
| **Orchestration** | Kubernetes (K3d) |
| **Registry** | Docker Registry 2 |

## 📊 Kubernetes Resources

- **Deployments**: 3 (Database, Backend, Frontend)
- **Services**: 3 (ClusterIP, NodePort, LoadBalancer)
- **ConfigMaps**: 3 (Database init, Frontend HTML, Nginx config)
- **Replicas**: Backend (2), Frontend (1), Database (1)

## 🔍 Monitoring & Debugging
```bash
# View all resources
kubectl get all -n shopapi

# Check pod logs
kubectl logs -f <pod-name> -n shopapi

# Describe pod
kubectl describe pod <pod-name> -n shopapi

# Execute into pod
kubectl exec -it <pod-name> -n shopapi -- /bin/sh

# Port forward for local testing
kubectl port-forward svc/backend-service 3000:3000 -n shopapi
```

## 🎯 Learning Objectives

This project demonstrates:

- ✅ Containerization with Docker
- ✅ Multi-container orchestration with Kubernetes
- ✅ Service discovery and networking
- ✅ ConfigMaps for configuration management
- ✅ Health checks and readiness probes
- ✅ Resource limits and requests
- ✅ LoadBalancer and NodePort services
- ✅ Deployment strategies
- ✅ Docker Registry usage

## 🚀 CI/CD Integration (Optional)

For automated deployments, you can integrate with:

- **GitHub Actions**
- **Jenkins**
- **GitLab CI**
- **Drone CI**

Example GitHub Actions workflow included in `.github/workflows/deploy.yml` (not shown here for brevity).

## 📝 License

MIT License - Feel free to use this for learning and portfolio projects!

## 👨‍💻 Author

**DevOps Engineer**  
Demonstrating Kubernetes, Docker, and CI/CD best practices

---

## ⭐ Star This Repository

If this helped you learn Kubernetes and DevOps, please give it a star! ⭐

---

## 📧 Contact

Have questions? Open an issue or reach out!

---

**Happy Learning! 🎉**
DevOps Engineer - Kubernetes & CI/CD Demo

##
