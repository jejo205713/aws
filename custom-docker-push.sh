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

# Create Dockerfile using echo
echo "# Use Amazon Linux as the base image" > Dockerfile
echo "FROM amazonlinux:latest" >> Dockerfile
echo "" >> Dockerfile
echo "# Install Nginx" >> Dockerfile
echo "RUN yum install -y nginx" >> Dockerfile
echo "" >> Dockerfile
echo "# Copy custom index.html" >> Dockerfile
echo "COPY index.html /usr/share/nginx/html/index.html" >> Dockerfile
echo "" >> Dockerfile
echo "# Expose port 80" >> Dockerfile
echo "EXPOSE 80" >> Dockerfile
echo "" >> Dockerfile
echo "# Start Nginx" >> Dockerfile
echo "CMD [\"nginx\", \"-g\", \"daemon off;\"]" >> Dockerfile

# Create a sample index.html
echo "<h1>Hello from my custom Nginx container!</h1>" > index.html

# Build Docker image
sudo docker build -t my-nginx-image .

# Run container (Optional test)
sudo docker run -d -p 8080:80 my-nginx-image

# Log in to Docker Hub
sudo docker login

# Tag Docker image (Replace 'your-dockerhub-username' with your actual username)
sudo docker tag my-nginx-image your-dockerhub-username/my-nginx-image:v1

# Push image to Docker Hub
sudo docker push your-dockerhub-username/my-nginx-image:v1

echo "✅ Setup complete! Your image is now on Docker Hub."
