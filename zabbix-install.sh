#!/bin/bash

# Define variables
DB_HOST="localhost"
DB_NAME="zabbix"
DB_USER="zabbix"
DB_PASSWORD="StrongPassword"
ZBX_VERSION="6.4"

# Update system
sudo apt update && sudo apt upgrade -y

# Install required packages
sudo apt install -y wget curl gnupg2 software-properties-common

# Add Zabbix repository
wget https://repo.zabbix.com/zabbix/$ZBX_VERSION/ubuntu/pool/main/z/zabbix-release/zabbix-release_$ZBX_VERSION-1+ubuntu$(lsb_release -rs)_all.deb
sudo dpkg -i zabbix-release_$ZBX_VERSION-1+ubuntu$(lsb_release -rs)_all.deb
sudo apt update

# Install Zabbix server, frontend, and agent
sudo apt install -y zabbix-server-mysql zabbix-frontend-php zabbix-nginx-conf zabbix-sql-scripts zabbix-agent

# Install MySQL server
sudo apt install -y mysql-server

# Secure MySQL installation
sudo mysql_secure_installation

# Create Zabbix database and user
sudo mysql -e "CREATE DATABASE $DB_NAME CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;"
sudo mysql -e "CREATE USER '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASSWORD';"
sudo mysql -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'localhost';"
sudo mysql -e "FLUSH PRIVILEGES;"

# Import initial schema
zcat /usr/share/zabbix-sql-scripts/mysql/server.sql.gz | mysql -u$DB_USER -p$DB_PASSWORD $DB_NAME

# Configure Zabbix server
sudo sed -i "s/# DBPassword=/DBPassword=$DB_PASSWORD/" /etc/zabbix/zabbix_server.conf

# Configure PHP for Zabbix frontend
sudo sed -i "s/^; php_value\[date.timezone\] =.*/php_value[date.timezone] = UTC/" /etc/zabbix/nginx.conf

# Enable and start services
sudo systemctl restart zabbix-server zabbix-agent nginx php8.1-fpm
sudo systemctl enable zabbix-server zabbix-agent nginx php8.1-fpm

# Output completion message
echo "Zabbix installation completed! Access it via http://your-server-ip/zabbix"
