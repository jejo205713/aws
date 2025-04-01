#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

# Update system packages
sudo yum update -y  

# Install Docker
sudo amazon-linux-extras enable docker
sudo yum install -y docker  

# Start and enable Docker
sudo systemctl start docker
sudo systemctl enable docker

# Create a project directory
mkdir -p ~/my-docker-app && cd ~/my-docker-app

# Create Dockerfile
cat <<EOF > Dockerfile
# Use Amazon Linux as the base image
FROM amazonlinux:latest  

# Install Nginx
RUN yum install -y nginx  

# Copy custom index.html
COPY index.html /usr/share/nginx/html/index.html  

# Expose port 80
EXPOSE 80  

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
EOF

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
