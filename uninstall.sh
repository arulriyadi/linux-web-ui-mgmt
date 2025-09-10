#!/bin/bash

# Web UI Management - Uninstaller
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
echo -e "${RED}"
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║                                                              ║"
echo "║           🗑️  Web UI Management Uninstaller 🗑️               ║"
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
       print_warning "Uninstallation cancelled by user."
       exit 0
   fi
fi

# Check if sudo is available
if ! command -v sudo &> /dev/null; then
    print_error "sudo is not installed. Please install sudo first."
    exit 1
fi

print_status "Starting Web UI Management uninstallation..."

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

# Get port number
print_question "What port was the web interface running on?"
echo -e "${YELLOW}Default: 8080${NC}"
read -p "Port number: " WEB_PORT
WEB_PORT=${WEB_PORT:-8080}

# Confirmation
echo
echo -e "${PURPLE}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${PURPLE}                    Uninstallation Summary                     ${NC}"
echo -e "${PURPLE}═══════════════════════════════════════════════════════════════${NC}"
echo -e "Service Name:      ${CYAN}$SERVICE_NAME${NC}"
echo -e "Installation Path: ${CYAN}$INSTALL_DIR${NC}"
echo -e "Web Port:          ${CYAN}$WEB_PORT${NC}"
echo -e "${PURPLE}═══════════════════════════════════════════════════════════════${NC}"
echo

print_warning "This will completely remove Web UI Management from your system!"
print_question "Are you sure you want to proceed? (y/N)"
read -p "Continue? " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    print_warning "Uninstallation cancelled by user."
    exit 0
fi

# Start uninstallation
print_status "Uninstalling Web UI Management..."

# Stop and disable services
print_status "Stopping and disabling services..."

# Stop main service
if sudo systemctl is-active --quiet $SERVICE_NAME; then
    sudo systemctl stop $SERVICE_NAME
    print_status "Main service stopped."
else
    print_warning "Main service was not running."
fi

# Stop rules loader service
if sudo systemctl is-active --quiet web-ui-mgmt-rules; then
    sudo systemctl stop web-ui-mgmt-rules
    print_status "Rules loader service stopped."
else
    print_warning "Rules loader service was not running."
fi

# Disable main service
if sudo systemctl is-enabled --quiet $SERVICE_NAME; then
    sudo systemctl disable $SERVICE_NAME
    print_status "Main service disabled."
else
    print_warning "Main service was not enabled."
fi

# Disable rules loader service
if sudo systemctl is-enabled --quiet web-ui-mgmt-rules; then
    sudo systemctl disable web-ui-mgmt-rules
    print_status "Rules loader service disabled."
else
    print_warning "Rules loader service was not enabled."
fi

# Remove systemd service files
print_status "Removing systemd service files..."

# Remove main service file
if [ -f "/etc/systemd/system/$SERVICE_NAME.service" ]; then
    sudo rm -f "/etc/systemd/system/$SERVICE_NAME.service"
    print_status "Main service file removed."
else
    print_warning "Main service file not found."
fi

# Remove rules loader service file
if [ -f "/etc/systemd/system/web-ui-mgmt-rules.service" ]; then
    sudo rm -f "/etc/systemd/system/web-ui-mgmt-rules.service"
    print_status "Rules loader service file removed."
else
    print_warning "Rules loader service file not found."
fi

# Reload systemd
sudo systemctl daemon-reload

# Remove firewall rule
print_status "Removing firewall rule..."
if command -v ufw &> /dev/null; then
    if sudo ufw status | grep -q "$WEB_PORT"; then
        sudo ufw delete allow $WEB_PORT/tcp
        print_status "Firewall rule removed."
    else
        print_warning "Firewall rule not found."
    fi
else
    print_warning "UFW not found. Please manually remove firewall rule for port $WEB_PORT"
fi

# Remove installation directory
print_status "Removing installation directory..."
if [ -d "$INSTALL_DIR" ]; then
    sudo rm -rf "$INSTALL_DIR"
    print_status "Installation directory removed."
else
    print_warning "Installation directory not found."
fi

# Remove any remaining processes
print_status "Checking for remaining processes..."
if pgrep -f "web-ui-mgmt" > /dev/null; then
    print_warning "Found remaining processes. Terminating..."
    sudo pkill -f "web-ui-mgmt"
    sleep 2
    print_status "Processes terminated."
else
    print_status "No remaining processes found."
fi

# Uninstallation complete
echo
echo -e "${GREEN}╔══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║                                                              ║${NC}"
echo -e "${GREEN}║              🎉 Uninstallation Complete! 🎉                 ║${NC}"
echo -e "${GREEN}║                                                              ║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════════════════════════════╝${NC}"
echo
print_status "Web UI Management has been completely removed from your system."
print_warning "Note: This uninstaller does not remove Go or other dependencies that may be used by other applications."
echo
print_status "Uninstallation completed successfully! 🚀"
