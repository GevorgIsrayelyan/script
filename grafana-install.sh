#!/bin/bash

# Update system packages
echo "Updating system packages..."
sudo apt update && sudo apt upgrade -y

# Install dependencies
echo "Installing dependencies..."
sudo apt install -y software-properties-common apt-transport-https wget

# Add Grafana APT repository
echo "Adding Grafana APT repository..."
wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -
echo "deb https://packages.grafana.com/oss/deb stable main" | sudo tee /etc/apt/sources.list.d/grafana.list

# Install Grafana
echo "Installing Grafana..."
sudo apt update && sudo apt install -y grafana

# Enable and start Grafana service
echo "Enabling and starting Grafana service..."
sudo systemctl enable grafana-server
sudo systemctl start grafana-server

# Check Grafana service status
echo "Grafana service status:"
sudo systemctl status grafana-server --no-pager

echo "Grafana installation completed. Access it at http://<server-ip>:3000"
