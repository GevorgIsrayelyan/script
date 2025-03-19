#!/bin/bash

# Update package lists
echo "Updating package lists..."
sudo apt update -y

# Install Nginx
echo "Installing Nginx..."
sudo apt install nginx -y

# Enable and start Nginx service
echo "Enabling and starting Nginx..."
sudo systemctl enable nginx
sudo systemctl start nginx

# Allow HTTP and HTTPS traffic through firewall
echo "Configuring firewall rules..."
sudo ufw allow 'Nginx Full'

# Verify installation
echo "Verifying Nginx status..."
systemctl status nginx --no-pager

echo "Nginx installation and setup complete."
