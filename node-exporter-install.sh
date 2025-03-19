#!/bin/bash

# Define Node Exporter version
VERSION="1.7.0"

# Create a Prometheus user if not exists
echo "Creating Prometheus system user..."
sudo useradd --no-create-home --shell /bin/false prometheus || true

# Download and extract Node Exporter
echo "Downloading Node Exporter..."
wget https://github.com/prometheus/node_exporter/releases/download/v$VERSION/node_exporter-$VERSION.linux-amd64.tar.gz

echo "Extracting Node Exporter..."
tar -xvf node_exporter-$VERSION.linux-amd64.tar.gz
cd node_exporter-$VERSION.linux-amd64/

# Move binaries
echo "Moving Node Exporter binary..."
sudo mv node_exporter /usr/local/bin/

# Set permissions
echo "Setting permissions..."
sudo chown prometheus:prometheus /usr/local/bin/node_exporter

# Create systemd service file
echo "Creating Node Exporter service..."
echo "[Unit]
Description=Prometheus Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
Group=prometheus
Type=simple
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=default.target" | sudo tee /etc/systemd/system/node_exporter.service

# Reload systemd and start Node Exporter
echo "Starting Node Exporter service..."
sudo systemctl daemon-reload
sudo systemctl enable node_exporter
sudo systemctl start node_exporter

# Check Node Exporter status
echo "Node Exporter service status:"
sudo systemctl status node_exporter --no-pager

echo "Node Exporter installation completed. Metrics available at http://<server-ip>:9100/metrics"
