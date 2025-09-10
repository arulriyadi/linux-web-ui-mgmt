#!/bin/bash

# Web UI Management - Interactive Installer
# Author: AI Assistant
# Version: 1.0

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Banner
echo -e "${CYAN}"
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║                                                              ║"
echo "║           🚀 Web UI Management Installer 🚀                 ║"
echo "║                                                              ║"
echo "║        Firewall & Routing Control Panel                     ║"
echo "║                                                              ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_question() {
    echo -e "${BLUE}[?]${NC} $1"
}

# Check if running as root (allow but warn)
if [[ $EUID -eq 0 ]]; then
   print_warning "Running as root user. This is allowed but not recommended for security reasons."
   print_warning "Consider running as a regular user with sudo privileges instead."
   echo
   print_question "Do you want to continue running as root? (y/N)"
   read -p "Continue? " -n 1 -r
   echo
   if [[ ! $REPLY =~ ^[Yy]$ ]]; then
       print_warning "Installation cancelled by user."
       exit 0
   fi
fi

# Check if sudo is available (only if not running as root)
if [[ $EUID -ne 0 ]] && ! command -v sudo &> /dev/null; then
    print_error "sudo is not installed. Please install sudo first."
    exit 1
fi

# Set command prefix based on user
if [[ $EUID -eq 0 ]]; then
    SUDO_CMD=""
else
    SUDO_CMD="sudo"
fi

print_status "Starting Web UI Management installation..."

# Get installation directory
print_question "Where would you like to install Web UI Management?"
echo -e "${YELLOW}Default: /opt/web-ui-mgmt${NC}"
read -p "Installation path: " INSTALL_DIR
INSTALL_DIR=${INSTALL_DIR:-/opt/web-ui-mgmt}

# Get admin username
print_question "What username would you like for admin access?"
echo -e "${YELLOW}Default: admin${NC}"
read -p "Admin username: " ADMIN_USER
ADMIN_USER=${ADMIN_USER:-admin}

# Get admin password
print_question "What password would you like for admin access?"
echo -e "${YELLOW}Default: admin123${NC}"
read -s -p "Admin password: " ADMIN_PASS
ADMIN_PASS=${ADMIN_PASS:-admin123}
echo

# Get port number
print_question "What port would you like the web interface to run on?"
echo -e "${YELLOW}Default: 8080${NC}"
read -p "Port number: " WEB_PORT
WEB_PORT=${WEB_PORT:-8080}

# Get host binding
print_question "Which IP address should the web interface bind to?"
echo -e "${YELLOW}Options: 0.0.0.0 (all interfaces), 127.0.0.1 (localhost only), or specific IP${NC}"
echo -e "${YELLOW}Default: 0.0.0.0${NC}"
read -p "Bind address: " BIND_ADDRESS
BIND_ADDRESS=${BIND_ADDRESS:-0.0.0.0}

# Get service name
print_question "What would you like to name the systemd service?"
echo -e "${YELLOW}Default: web-ui-mgmt${NC}"
read -p "Service name: " SERVICE_NAME
SERVICE_NAME=${SERVICE_NAME:-web-ui-mgmt}

# Confirmation
echo
echo -e "${PURPLE}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${PURPLE}                    Installation Summary                        ${NC}"
echo -e "${PURPLE}═══════════════════════════════════════════════════════════════${NC}"
echo -e "Installation Path: ${CYAN}$INSTALL_DIR${NC}"
echo -e "Admin Username:    ${CYAN}$ADMIN_USER${NC}"
echo -e "Admin Password:    ${CYAN}$ADMIN_PASS${NC}"
echo -e "Web Port:          ${CYAN}$WEB_PORT${NC}"
echo -e "Bind Address:      ${CYAN}$BIND_ADDRESS${NC}"
echo -e "Service Name:      ${CYAN}$SERVICE_NAME${NC}"
echo -e "${PURPLE}═══════════════════════════════════════════════════════════════${NC}"
echo

print_question "Do you want to proceed with the installation? (y/N)"
read -p "Continue? " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    print_warning "Installation cancelled by user."
    exit 0
fi

# Start installation
print_status "Installing Web UI Management..."

# Update system
print_status "Updating system packages..."
$SUDO_CMD apt update

# Install dependencies
print_status "Installing dependencies..."
$SUDO_CMD apt install -y golang-go curl wget unzip

# Create installation directory
print_status "Creating installation directory..."
$SUDO_CMD mkdir -p "$INSTALL_DIR"
if [[ $EUID -ne 0 ]]; then
    $SUDO_CMD chown $USER:$USER "$INSTALL_DIR"
fi

# Copy files
print_status "Copying application files..."
cp -r . "$INSTALL_DIR/"
cd "$INSTALL_DIR"

# Create config.json
print_status "Creating configuration file..."
cat > config.json << EOF
{
    "server": {
        "host": "$BIND_ADDRESS",
        "port": $WEB_PORT
    },
    "auth": {
        "username": "$ADMIN_USER",
        "password": "$ADMIN_PASS"
    },
    "system": {
        "iptables_path": "/sbin/iptables",
        "ip_path": "/sbin/ip"
    }
}
EOF

# Build application
print_status "Building application..."
cd backend
go mod tidy
go build -o web-ui-mgmt main.go
cd ..

# Set permissions
print_status "Setting permissions..."
chmod +x start.sh
chmod +x test.sh
chmod +x demo.sh
chmod +x backend/web-ui-mgmt

# Create systemd service
print_status "Creating systemd service..."
$SUDO_CMD tee /etc/systemd/system/$SERVICE_NAME.service > /dev/null << EOF
[Unit]
Description=Web UI Management - Firewall & Routing Control Panel
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=$INSTALL_DIR
ExecStart=$INSTALL_DIR/backend/web-ui-mgmt
Restart=always
RestartSec=5
Environment=PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

[Install]
WantedBy=multi-user.target
EOF

# Enable and start service
print_status "Enabling and starting service..."
$SUDO_CMD systemctl daemon-reload
$SUDO_CMD systemctl enable $SERVICE_NAME
$SUDO_CMD systemctl start $SERVICE_NAME

# Configure firewall
print_status "Configuring firewall..."
if command -v ufw &> /dev/null; then
    $SUDO_CMD ufw allow $WEB_PORT/tcp
    print_status "UFW firewall rule added for port $WEB_PORT"
else
    print_warning "UFW not found. Please manually configure firewall for port $WEB_PORT"
fi

# Wait for service to start
print_status "Waiting for service to start..."
sleep 3

# Check service status
if $SUDO_CMD systemctl is-active --quiet $SERVICE_NAME; then
    print_status "Service is running successfully!"
else
    print_error "Service failed to start. Checking logs..."
    $SUDO_CMD systemctl status $SERVICE_NAME
    exit 1
fi

# Get local IP
LOCAL_IP=$(hostname -I | awk '{print $1}')

# Installation complete
echo
echo -e "${GREEN}╔══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║                                                              ║${NC}"
echo -e "${GREEN}║              🎉 Installation Complete! 🎉                   ║${NC}"
echo -e "${GREEN}║                                                              ║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════════════════════════════╝${NC}"
echo
echo -e "${CYAN}Access your Web UI Management at:${NC}"
echo -e "  Local:   ${YELLOW}http://localhost:$WEB_PORT${NC}"
echo -e "  Network: ${YELLOW}http://$LOCAL_IP:$WEB_PORT${NC}"
echo
echo -e "${CYAN}Login Credentials:${NC}"
echo -e "  Username: ${YELLOW}$ADMIN_USER${NC}"
echo -e "  Password: ${YELLOW}$ADMIN_PASS${NC}"
echo
echo -e "${CYAN}Service Management:${NC}"
echo -e "  Start:   ${YELLOW}sudo systemctl start $SERVICE_NAME${NC}"
echo -e "  Stop:    ${YELLOW}sudo systemctl stop $SERVICE_NAME${NC}"
echo -e "  Status:  ${YELLOW}sudo systemctl status $SERVICE_NAME${NC}"
echo -e "  Logs:    ${YELLOW}sudo journalctl -u $SERVICE_NAME -f${NC}"
echo
echo -e "${CYAN}Installation Directory:${NC}"
echo -e "  ${YELLOW}$INSTALL_DIR${NC}"
echo
print_status "Web UI Management is now ready to use! 🚀"
