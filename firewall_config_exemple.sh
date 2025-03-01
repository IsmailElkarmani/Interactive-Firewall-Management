#!/bin/bash

# Example firewall configuration script for a basic web server setup
# This configuration allows SSH (port 22) and HTTP (port 80) traffic,
# while denying all other incoming traffic.

# Default firewall policy: deny incoming, allow outgoing
echo "Setting default policies..."
sudo iptables -P INPUT DROP
sudo iptables -P FORWARD DROP
sudo iptables -P OUTPUT ACCEPT

# Allow incoming SSH (port 22) and HTTP (port 80) traffic
echo "Allowing SSH and HTTP traffic..."
sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT

# Allow incoming traffic for localhost (loopback interface)
echo "Allowing traffic on the loopback interface..."
sudo iptables -A INPUT -i lo -j ACCEPT

# Allow incoming ICMP (ping) requests
echo "Allowing ICMP (ping) requests..."
sudo iptables -A INPUT -p icmp --icmp-type echo-request -j ACCEPT

# Save the firewall configuration
echo "Saving firewall configuration..."
sudo iptables-save > /etc/iptables/rules.v4

# Optionally, you can create a backup of your configuration
echo "Backing up current firewall rules..."
sudo iptables-save > backup.rules

echo "Firewall configuration applied successfully!"
