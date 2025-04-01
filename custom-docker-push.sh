#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

# Update system packages
sudo yum update -y  

# Install Docker
sudo yum install -y docker  

# Start and enable Docker
sudo systemctl start docker
sudo systemctl enable docker

# Create a project directory
mkdir -p ~/my-docker-app && cd ~/my-docker-app

# Define a specific Dockerfile name
dockerfile_name="Dockerfile.custom"

# Create Dockerfile using echo
echo "# Use Amazon Linux as the base image" > $dockerfile_name
echo "FROM amazonlinux:latest" >> $dockerfile_name
echo "" >> $dockerfile_name
echo "# Install Nginx" >> $dockerfile_name
echo "RUN yum install -y nginx" >> $dockerfile_name
echo "" >> $dockerfile_name
echo "# Copy custom index.html" >> $dockerfile_name
echo "COPY index.html /usr/share/nginx/html/index.html" >> $dockerfile_name
echo "" >> $dockerfile_name
echo "# Expose port 80" >> $dockerfile_name
echo "EXPOSE 80" >> $dockerfile_name
echo "" >> $dockerfile_name
echo "# Start Nginx" >> $dockerfile_name
echo "CMD [\"nginx\", \"-g\", \"daemon off;\"]" >> $dockerfile_name

# Create a sample index.html
echo "<h1>Hello from my custom Nginx container!</h1>" > index.html

# Define specific Docker image and repository names
dockerhub_username="jejo205713"
image_name="custom-nginx"
repo_name="$dockerhub_username/$image_name"

# Build Docker image
sudo docker build -t $repo_name:v1 -f $dockerfile_name .

# Run container (Optional test)
sudo docker run -d -p 8080:80 $repo_name:v1

# Log in to Docker Hub
sudo docker login

# Push image to Docker Hub
sudo docker push $repo_name:v1

echo "✅ Setup complete! Your image '$repo_name:v1' is now on Docker Hub."
