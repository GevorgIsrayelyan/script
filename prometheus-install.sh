#!/bin/bash

# Define Prometheus version
VERSION="2.51.2"

# Create a Prometheus user
echo "Creating Prometheus system user..."
sudo useradd --no-create-home --shell /bin/false prometheus

# Create directories
echo "Creating directories..."
sudo mkdir /etc/prometheus
sudo mkdir /var/lib/prometheus

# Download and extract Prometheus
echo "Downloading Prometheus..."
wget https://github.com/prometheus/prometheus/releases/download/v$VERSION/prometheus-$VERSION.linux-amd64.tar.gz

echo "Extracting Prometheus..."
tar -xvf prometheus-$VERSION.linux-amd64.tar.gz
cd prometheus-$VERSION.linux-amd64/

# Move binaries
echo "Moving Prometheus binaries..."
sudo mv prometheus /usr/local/bin/
sudo mv promtool /usr/local/bin/

# Set permissions
echo "Setting permissions..."
sudo chown prometheus:prometheus /usr/local/bin/prometheus
sudo chown prometheus:prometheus /usr/local/bin/promtool

# Move configuration files
echo "Moving configuration files..."
sudo mv consoles /etc/prometheus/
sudo mv console_libraries /etc/prometheus/
sudo mv prometheus.yml /etc/prometheus/

# Set directory permissions
sudo chown -R prometheus:prometheus /etc/prometheus
sudo chown -R prometheus:prometheus /var/lib/prometheus

# Create systemd service file
echo "Creating Prometheus service..."
echo "[Unit]
Description=Prometheus Time Series Collection and Processing Server
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
Group=prometheus
Type=simple
ExecStart=/usr/local/bin/prometheus \
  --config.file=/etc/prometheus/prometheus.yml \
  --storage.tsdb.path=/var/lib/prometheus/ \
  --web.console.templates=/etc/prometheus/consoles \
  --web.console.libraries=/etc/prometheus/console_libraries \
  --web.listen-address=0.0.0.0:9090

[Install]
WantedBy=multi-user.target" | sudo tee /etc/systemd/system/prometheus.service

# Reload systemd and start Prometheus
echo "Starting Prometheus service..."
sudo systemctl daemon-reload
sudo systemctl enable prometheus
sudo systemctl start prometheus

# Check Prometheus status
sudo systemctl status prometheus --no-pager
