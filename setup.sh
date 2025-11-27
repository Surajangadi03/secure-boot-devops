#!/bin/bash

set -e   # Stop script if any command fails

echo " STEP 1: Building Docker Image"

eval $(minikube docker-env)
docker build -t secure-boot:latest .

echo " STEP 2: Running Terraform"

cd terraform
terraform init
terraform apply -auto-approve
cd ..

echo "STEP 3: Deploying with Helm"

helm upgrade --install secure-boot ./helm/secure-boot -n devops-challenge --create-namespace

echo "SETUP COMPLETE SUCCESSFULL"

