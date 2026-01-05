#!/bin/bash

echo "======================================"
echo "🔨 Building and Pushing Images"
echo "======================================"
echo ""

# Get registry IP
read -p "Enter Registry IP (Node 2 IP): " REGISTRY_IP

echo "Building backend image..."
cd backend
docker build -t $REGISTRY_IP:5000/shopapi-backend:latest .

echo "Pushing to registry..."
docker push $REGISTRY_IP:5000/shopapi-backend:latest

echo ""
echo "✅ Backend image pushed to $REGISTRY_IP:5000"
echo ""
echo "======================================"
echo "✅ Build complete!"
echo "======================================"
