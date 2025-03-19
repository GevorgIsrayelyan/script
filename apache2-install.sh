#!/bin/bash

# Update system
sudo apt update && sudo apt upgrade -y

# Install Apache2
sudo apt install -y apache2

# Enable Apache to start on boot
sudo systemctl enable apache2

# Start Apache service
sudo systemctl start apache2

# Allow Apache through firewall
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw reload

# Set up a simple test page
echo "<html><body><h1>Apache2 Installed Successfully</h1></body></html>" | sudo tee /var/www/html/index.html

# Restart Apache to apply changes
sudo systemctl restart apache2

# Output completion message
echo "Apache2 installation completed! Access it via http://your-server-ip/"
