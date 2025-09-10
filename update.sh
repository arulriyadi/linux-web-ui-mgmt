#!/bin/bash

# Web UI Management - Updater
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
echo -e "${BLUE}"
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║                                                              ║"
echo "║           🔄 Web UI Management Updater 🔄                    ║"
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
       print_warning "Update cancelled by user."
       exit 0
   fi
fi

# Check if sudo is available
if ! command -v sudo &> /dev/null; then
    print_error "sudo is not installed. Please install sudo first."
    exit 1
fi

print_status "Starting Web UI Management update..."

# Get service name
print_question "What is the name of the Web UI Management service?"
echo -e "${YELLOW}Default: web-ui-mgmt${NC}"
read -p "Service name: " SERVICE_NAME
SERVICE_NAME=${SERVICE_NAME:-web-ui-mgmt}

# Get installation directory
print_question "Where is Web UI Management installed?"
echo -e "${YELLOW}Default: /opt/web-ui-mgmt${NC}"
read -p "Installation path: " INSTALL_DIR
INSTALL_DIR=${INSTALL_DIR:-/opt/web-ui-mgmt}

# Check if installation exists
if [ ! -d "$INSTALL_DIR" ]; then
    print_error "Installation directory not found: $INSTALL_DIR"
    print_warning "Please make sure Web UI Management is installed first."
    exit 1
fi

# Backup current config
print_status "Backing up current configuration..."
if [ -f "$INSTALL_DIR/config.json" ]; then
    cp "$INSTALL_DIR/config.json" "$INSTALL_DIR/config.json.backup.$(date +%Y%m%d_%H%M%S)"
    print_status "Configuration backed up."
else
    print_warning "No configuration file found to backup."
fi

# Stop service
print_status "Stopping service..."
if sudo systemctl is-active --quiet $SERVICE_NAME; then
    sudo systemctl stop $SERVICE_NAME
    print_status "Service stopped."
else
    print_warning "Service was not running."
fi

# Update application files
print_status "Updating application files..."
cd "$INSTALL_DIR"

# If this is a git repository, pull updates
if [ -d ".git" ]; then
    print_status "Pulling updates from git repository..."
    git pull origin main
else
    print_warning "Not a git repository. Please manually update the files."
    print_question "Do you want to continue with the update? (y/N)"
    read -p "Continue? " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_warning "Update cancelled by user."
        exit 0
    fi
fi

# Build application
print_status "Building updated application..."
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

# Restore config if backup exists
if [ -f "config.json.backup.$(date +%Y%m%d_%H%M%S)" ]; then
    print_status "Restoring configuration..."
    cp "config.json.backup.$(date +%Y%m%d_%H%M%S)" "config.json"
    print_status "Configuration restored."
fi

# Start service
print_status "Starting updated service..."
sudo systemctl start $SERVICE_NAME

# Wait for service to start
print_status "Waiting for service to start..."
sleep 3

# Check service status
if sudo systemctl is-active --quiet $SERVICE_NAME; then
    print_status "Service is running successfully!"
else
    print_error "Service failed to start. Checking logs..."
    sudo systemctl status $SERVICE_NAME
    exit 1
fi

# Get local IP
LOCAL_IP=$(hostname -I | awk '{print $1}')

# Get port from config
WEB_PORT=$(grep -o '"port": [0-9]*' config.json | grep -o '[0-9]*')

# Update complete
echo
echo -e "${GREEN}╔══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║                                                              ║${NC}"
echo -e "${GREEN}║              🎉 Update Complete! 🎉                         ║${NC}"
echo -e "${GREEN}║                                                              ║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════════════════════════════╝${NC}"
echo
echo -e "${CYAN}Access your updated Web UI Management at:${NC}"
echo -e "  Local:   ${YELLOW}http://localhost:$WEB_PORT${NC}"
echo -e "  Network: ${YELLOW}http://$LOCAL_IP:$WEB_PORT${NC}"
echo
echo -e "${CYAN}Service Management:${NC}"
echo -e "  Status:  ${YELLOW}sudo systemctl status $SERVICE_NAME${NC}"
echo -e "  Logs:    ${YELLOW}sudo journalctl -u $SERVICE_NAME -f${NC}"
echo
print_status "Web UI Management has been successfully updated! 🚀"
