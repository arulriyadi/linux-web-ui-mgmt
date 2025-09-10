#!/bin/bash

# Web UI Management - Package Creator
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
echo -e "${PURPLE}"
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║                                                              ║"
echo "║           📦 Web UI Management Package Creator 📦             ║"
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

# Get version
print_question "What version is this release?"
echo -e "${YELLOW}Default: 1.0.0${NC}"
read -p "Version: " VERSION
VERSION=${VERSION:-1.0.0}

# Get package name
PACKAGE_NAME="web-ui-mgmt-${VERSION}"
PACKAGE_DIR="dist/${PACKAGE_NAME}"

print_status "Creating package: $PACKAGE_NAME"

# Create distribution directory
print_status "Creating distribution directory..."
mkdir -p "$PACKAGE_DIR"

# Copy application files
print_status "Copying application files..."
cp -r backend "$PACKAGE_DIR/"
cp -r frontend "$PACKAGE_DIR/"
cp -r docker "$PACKAGE_DIR/"
cp config.json "$PACKAGE_DIR/"
cp README.md "$PACKAGE_DIR/"
cp Makefile "$PACKAGE_DIR/"

# Copy scripts
print_status "Copying installation scripts..."
cp install.sh "$PACKAGE_DIR/"
cp uninstall.sh "$PACKAGE_DIR/"
cp update.sh "$PACKAGE_DIR/"
cp start.sh "$PACKAGE_DIR/"
cp test.sh "$PACKAGE_DIR/"
cp demo.sh "$PACKAGE_DIR/"

# Set permissions
print_status "Setting permissions..."
chmod +x "$PACKAGE_DIR"/*.sh

# Create package info file
print_status "Creating package info..."
cat > "$PACKAGE_DIR/PACKAGE_INFO" << EOF
Web UI Management Package
Version: $VERSION
Created: $(date)
Author: AI Assistant

Installation:
1. Extract this package
2. Run: ./install.sh
3. Follow the interactive prompts

Uninstallation:
1. Run: ./uninstall.sh

Update:
1. Run: ./update.sh

Manual Installation:
1. Extract this package
2. Run: make build
3. Run: sudo ./start.sh
EOF

# Create changelog
print_status "Creating changelog..."
cat > "$PACKAGE_DIR/CHANGELOG.md" << EOF
# Changelog

## Version $VERSION - $(date +%Y-%m-%d)

### Features
- Interactive installer with customizable settings
- Dark theme UI with glassmorphism effects
- Full-screen login layout
- Systemd service integration
- Firewall auto-configuration
- Cross-platform compatibility

### Installation
- Run \`./install.sh\` for interactive installation
- Supports custom username, password, port, and installation path
- Automatic systemd service creation
- UFW firewall rule management

### Uninstallation
- Run \`./uninstall.sh\` for complete removal
- Removes service, files, and firewall rules

### Update
- Run \`./update.sh\` for seamless updates
- Preserves configuration during updates
EOF

# Create README for package
print_status "Creating package README..."
cat > "$PACKAGE_DIR/README.md" << EOF
# Web UI Management v$VERSION

A lightweight web-based management interface for iptables and ip route commands.

## Quick Start

### Interactive Installation (Recommended)
\`\`\`bash
./install.sh
\`\`\`

The installer will ask you for:
- Installation directory (default: /opt/web-ui-mgmt)
- Admin username (default: admin)
- Admin password (default: admin123)
- Web port (default: 8080)
- Bind address (default: 0.0.0.0)
- Service name (default: web-ui-mgmt)

### Manual Installation
\`\`\`bash
make build
sudo ./start.sh
\`\`\`

### Docker Installation
\`\`\`bash
docker-compose up -d
\`\`\`

## Access

After installation, access the web interface at:
- Local: http://localhost:8080
- Network: http://YOUR_IP:8080

Default credentials:
- Username: admin
- Password: admin123

## Management

### Service Control
\`\`\`bash
sudo systemctl start web-ui-mgmt    # Start service
sudo systemctl stop web-ui-mgmt     # Stop service
sudo systemctl status web-ui-mgmt   # Check status
sudo journalctl -u web-ui-mgmt -f   # View logs
\`\`\`

### Uninstallation
\`\`\`bash
./uninstall.sh
\`\`\`

### Update
\`\`\`bash
./update.sh
\`\`\`

## Features

- 🎨 Modern dark theme UI
- 🔐 JWT-based authentication
- 🛡️ Firewall rules management
- 🛣️ Routing table management
- 📊 System information dashboard
- 🔄 Real-time updates
- 📱 Responsive design
- 🐳 Docker support
- ⚙️ Systemd integration

## Requirements

- Ubuntu 18.04+ or similar Linux distribution
- Go 1.18+ (for manual installation)
- sudo privileges
- iptables and iproute2 tools

## Support

For issues and feature requests, please check the documentation or contact support.
EOF

# Create tar.gz package
print_status "Creating compressed package..."
cd dist
tar -czf "${PACKAGE_NAME}.tar.gz" "$PACKAGE_NAME"
cd ..

# Create zip package
print_status "Creating zip package..."
cd dist
zip -r "${PACKAGE_NAME}.zip" "$PACKAGE_NAME"
cd ..

# Get package sizes
TAR_SIZE=$(du -h "dist/${PACKAGE_NAME}.tar.gz" | cut -f1)
ZIP_SIZE=$(du -h "dist/${PACKAGE_NAME}.zip" | cut -f1)

# Package creation complete
echo
echo -e "${GREEN}╔══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║                                                              ║${NC}"
echo -e "${GREEN}║              🎉 Package Created Successfully! 🎉             ║${NC}"
echo -e "${GREEN}║                                                              ║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════════════════════════════╝${NC}"
echo
echo -e "${CYAN}Package Information:${NC}"
echo -e "  Name:     ${YELLOW}$PACKAGE_NAME${NC}"
echo -e "  Version:  ${YELLOW}$VERSION${NC}"
echo -e "  Date:     ${YELLOW}$(date)${NC}"
echo
echo -e "${CYAN}Package Files:${NC}"
echo -e "  Directory: ${YELLOW}dist/$PACKAGE_NAME/${NC}"
echo -e "  Tar.gz:    ${YELLOW}dist/${PACKAGE_NAME}.tar.gz${NC} (${TAR_SIZE})"
echo -e "  Zip:       ${YELLOW}dist/${PACKAGE_NAME}.zip${NC} (${ZIP_SIZE})"
echo
echo -e "${CYAN}Installation Instructions:${NC}"
echo -e "  1. Extract the package: ${YELLOW}tar -xzf ${PACKAGE_NAME}.tar.gz${NC}"
echo -e "  2. Enter directory:     ${YELLOW}cd $PACKAGE_NAME${NC}"
echo -e "  3. Run installer:       ${YELLOW}./install.sh${NC}"
echo
print_status "Package creation completed successfully! 🚀"
