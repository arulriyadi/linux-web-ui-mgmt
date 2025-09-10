#!/bin/bash

# Web UI Management - Interactive Help
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
echo "║           📚 Web UI Management Help Center 📚                 ║"
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

print_header() {
    echo -e "${PURPLE}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${PURPLE}$1${NC}"
    echo -e "${PURPLE}═══════════════════════════════════════════════════════════════${NC}"
}

# Main help menu
show_main_menu() {
    echo
    print_header "                    Help Menu                        "
    echo
    echo -e "${CYAN}What would you like help with?${NC}"
    echo
    echo -e "${YELLOW}1.${NC} 📥 Installation Help"
    echo -e "${YELLOW}2.${NC} 🗑️  Uninstallation Help"
    echo -e "${YELLOW}3.${NC} 🔄 Update Help"
    echo -e "${YELLOW}4.${NC} 📦 Package Creation Help"
    echo -e "${YELLOW}5.${NC} 🔧 Troubleshooting"
    echo -e "${YELLOW}6.${NC} ⚙️  Configuration Help"
    echo -e "${YELLOW}7.${NC} 🌐 Access & Usage"
    echo -e "${YELLOW}8.${NC} 📋 All Scripts Overview"
    echo -e "${YELLOW}9.${NC} ❓ FAQ"
    echo -e "${YELLOW}0.${NC} 🚪 Exit"
    echo
    print_question "Enter your choice (0-9):"
}

# Installation help
show_installation_help() {
    print_header "                    Installation Help                 "
    echo
    echo -e "${CYAN}📥 Interactive Installation with install.sh${NC}"
    echo
    echo -e "${YELLOW}Quick Start:${NC}"
    echo -e "  ${GREEN}./install.sh${NC}"
    echo
    echo -e "${YELLOW}Questions you'll be asked:${NC}"
    echo
    echo -e "${BLUE}1. Installation Directory:${NC}"
    echo -e "   Default: ${GREEN}/opt/web-ui-mgmt${NC}"
    echo -e "   Custom:  ${GREEN}/home/user/web-ui-mgmt${NC}"
    echo
    echo -e "${BLUE}2. Admin Username:${NC}"
    echo -e "   Default: ${GREEN}admin${NC}"
    echo -e "   Custom:  ${GREEN}firewall-admin${NC}"
    echo
    echo -e "${BLUE}3. Admin Password:${NC}"
    echo -e "   Default: ${GREEN}admin123${NC}"
    echo -e "   Custom:  ${GREEN}MySecurePass123!${NC}"
    echo
    echo -e "${BLUE}4. Web Port:${NC}"
    echo -e "   Default: ${GREEN}8080${NC}"
    echo -e "   Custom:  ${GREEN}3000, 8443, 9090${NC}"
    echo
    echo -e "${BLUE}5. Bind Address:${NC}"
    echo -e "   Default: ${GREEN}0.0.0.0${NC} (all interfaces)"
    echo -e "   Local:   ${GREEN}127.0.0.1${NC} (localhost only)"
    echo -e "   Custom:  ${GREEN}192.168.1.100${NC} (specific IP)"
    echo
    echo -e "${BLUE}6. Service Name:${NC}"
    echo -e "   Default: ${GREEN}web-ui-mgmt${NC}"
    echo -e "   Custom:  ${GREEN}firewall-manager${NC}"
    echo
    echo -e "${YELLOW}What happens during installation:${NC}"
    echo -e "  ✅ System packages updated"
    echo -e "  ✅ Dependencies installed (Go, curl, wget, unzip)"
    echo -e "  ✅ Installation directory created"
    echo -e "  ✅ Application files copied"
    echo -e "  ✅ Configuration file created"
    echo -e "  ✅ Application built"
    echo -e "  ✅ Permissions set"
    echo -e "  ✅ Systemd service created"
    echo -e "  ✅ Service enabled and started"
    echo -e "  ✅ Firewall rules configured"
    echo -e "  ✅ Service status verified"
    echo
    echo -e "${YELLOW}After installation:${NC}"
    echo -e "  🌐 Access: ${GREEN}http://localhost:8080${NC}"
    echo -e "  👤 Login:  ${GREEN}admin / admin123${NC}"
    echo
    print_question "Press Enter to continue..."
    read
}

# Uninstallation help
show_uninstallation_help() {
    print_header "                    Uninstallation Help               "
    echo
    echo -e "${CYAN}🗑️ Complete Removal with uninstall.sh${NC}"
    echo
    echo -e "${YELLOW}Quick Start:${NC}"
    echo -e "  ${GREEN}./uninstall.sh${NC}"
    echo
    echo -e "${YELLOW}Questions you'll be asked:${NC}"
    echo
    echo -e "${BLUE}1. Service Name:${NC}"
    echo -e "   Default: ${GREEN}web-ui-mgmt${NC}"
    echo -e "   Custom:  ${GREEN}firewall-manager${NC}"
    echo
    echo -e "${BLUE}2. Installation Directory:${NC}"
    echo -e "   Default: ${GREEN}/opt/web-ui-mgmt${NC}"
    echo -e "   Custom:  ${GREEN}/home/user/web-ui-mgmt${NC}"
    echo
    echo -e "${BLUE}3. Web Port:${NC}"
    echo -e "   Default: ${GREEN}8080${NC}"
    echo -e "   Custom:  ${GREEN}3000, 8443, 9090${NC}"
    echo
    echo -e "${YELLOW}What happens during uninstallation:${NC}"
    echo -e "  ✅ Service stopped"
    echo -e "  ✅ Service disabled"
    echo -e "  ✅ Service file removed"
    echo -e "  ✅ Firewall rules removed"
    echo -e "  ✅ Installation directory removed"
    echo -e "  ✅ Running processes terminated"
    echo -e "  ✅ System cleaned up"
    echo
    echo -e "${RED}⚠️  WARNING: This will completely remove Web UI Management!${NC}"
    echo
    print_question "Press Enter to continue..."
    read
}

# Update help
show_update_help() {
    print_header "                    Update Help                       "
    echo
    echo -e "${CYAN}🔄 Seamless Update with update.sh${NC}"
    echo
    echo -e "${YELLOW}Quick Start:${NC}"
    echo -e "  ${GREEN}./update.sh${NC}"
    echo
    echo -e "${YELLOW}Questions you'll be asked:${NC}"
    echo
    echo -e "${BLUE}1. Service Name:${NC}"
    echo -e "   Default: ${GREEN}web-ui-mgmt${NC}"
    echo -e "   Custom:  ${GREEN}firewall-manager${NC}"
    echo
    echo -e "${BLUE}2. Installation Directory:${NC}"
    echo -e "   Default: ${GREEN}/opt/web-ui-mgmt${NC}"
    echo -e "   Custom:  ${GREEN}/home/user/web-ui-mgmt${NC}"
    echo
    echo -e "${YELLOW}What happens during update:${NC}"
    echo -e "  ✅ Current configuration backed up"
    echo -e "  ✅ Service stopped"
    echo -e "  ✅ Latest changes pulled (if git repo)"
    echo -e "  ✅ Application rebuilt"
    echo -e "  ✅ Permissions set"
    echo -e "  ✅ Configuration restored"
    echo -e "  ✅ Service started"
    echo -e "  ✅ Service status verified"
    echo
    echo -e "${YELLOW}After update:${NC}"
    echo -e "  🌐 Access: ${GREEN}http://localhost:8080${NC}"
    echo -e "  📊 Status: ${GREEN}sudo systemctl status web-ui-mgmt${NC}"
    echo
    print_question "Press Enter to continue..."
    read
}

# Package creation help
show_package_help() {
    print_header "                    Package Creation Help             "
    echo
    echo -e "${CYAN}📦 Create Distribution Package with create-package.sh${NC}"
    echo
    echo -e "${YELLOW}Quick Start:${NC}"
    echo -e "  ${GREEN}./create-package.sh${NC}"
    echo
    echo -e "${YELLOW}Questions you'll be asked:${NC}"
    echo
    echo -e "${BLUE}1. Version Number:${NC}"
    echo -e "   Default: ${GREEN}1.0.0${NC}"
    echo -e "   Custom:  ${GREEN}1.2.3, 2.0.0-beta${NC}"
    echo
    echo -e "${YELLOW}What happens during package creation:${NC}"
    echo -e "  ✅ Distribution directory created"
    echo -e "  ✅ Application files copied"
    echo -e "  ✅ Installation scripts copied"
    echo -e "  ✅ Permissions set"
    echo -e "  ✅ Package info created"
    echo -e "  ✅ Changelog generated"
    echo -e "  ✅ README created"
    echo -e "  ✅ Tar.gz package created"
    echo -e "  ✅ Zip package created"
    echo
    echo -e "${YELLOW}After package creation:${NC}"
    echo -e "  📦 Files: ${GREEN}dist/web-ui-mgmt-1.0.0.tar.gz${NC}"
    echo -e "  📦 Files: ${GREEN}dist/web-ui-mgmt-1.0.0.zip${NC}"
    echo
    print_question "Press Enter to continue..."
    read
}

# Troubleshooting help
show_troubleshooting_help() {
    print_header "                    Troubleshooting Help               "
    echo
    echo -e "${CYAN}🔧 Common Issues and Solutions${NC}"
    echo
    echo -e "${YELLOW}1. Permission Denied${NC}"
    echo -e "   Error: ${RED}Permission denied${NC}"
    echo -e "   Solution: ${GREEN}chmod +x *.sh${NC}"
    echo
    echo -e "${YELLOW}2. Service Won't Start${NC}"
    echo -e "   Error: ${RED}Service fails to start${NC}"
    echo -e "   Solution: ${GREEN}sudo journalctl -u web-ui-mgmt -f${NC}"
    echo -e "   Solution: ${GREEN}sudo systemctl status web-ui-mgmt${NC}"
    echo
    echo -e "${YELLOW}3. Port Already in Use${NC}"
    echo -e "   Error: ${RED}Port 8080 is already in use${NC}"
    echo -e "   Solution: ${GREEN}sudo netstat -tlnp | grep :8080${NC}"
    echo -e "   Solution: ${GREEN}sudo kill -9 <PID>${NC}"
    echo
    echo -e "${YELLOW}4. Go Not Found${NC}"
    echo -e "   Error: ${RED}go: command not found${NC}"
    echo -e "   Solution: ${GREEN}sudo apt install golang-go${NC}"
    echo
    echo -e "${YELLOW}5. Sudo Required${NC}"
    echo -e "   Error: ${RED}Script requires sudo privileges${NC}"
    echo -e "   Solution: ${GREEN}sudo usermod -aG sudo \$USER${NC}"
    echo -e "   Solution: ${GREEN}sudo ./install.sh${NC}"
    echo
    echo -e "${YELLOW}Log Locations:${NC}"
    echo -e "  📋 Service logs: ${GREEN}sudo journalctl -u web-ui-mgmt -f${NC}"
    echo -e "  📋 Application logs: ${GREEN}Check terminal output${NC}"
    echo -e "  📋 System logs: ${GREEN}/var/log/syslog${NC}"
    echo
    print_question "Press Enter to continue..."
    read
}

# Configuration help
show_configuration_help() {
    print_header "                    Configuration Help                "
    echo
    echo -e "${CYAN}⚙️ Configuration Management${NC}"
    echo
    echo -e "${YELLOW}Configuration File Location:${NC}"
    echo -e "  📁 ${GREEN}/opt/web-ui-mgmt/config.json${NC}"
    echo
    echo -e "${YELLOW}Edit Configuration:${NC}"
    echo -e "  ${GREEN}sudo nano /opt/web-ui-mgmt/config.json${NC}"
    echo -e "  ${GREEN}sudo systemctl restart web-ui-mgmt${NC}"
    echo
    echo -e "${YELLOW}Configuration Options:${NC}"
    echo -e "  🌐 Server host and port"
    echo -e "  👤 Admin username and password"
    echo -e "  🛠️ System tool paths"
    echo
    echo -e "${YELLOW}Change Admin Password:${NC}"
    echo -e "  1. Edit config file"
    echo -e "  2. Change password field"
    echo -e "  3. Restart service"
    echo
    echo -e "${YELLOW}Backup Configuration:${NC}"
    echo -e "  ${GREEN}cp /opt/web-ui-mgmt/config.json /opt/web-ui-mgmt/config.json.backup${NC}"
    echo
    print_question "Press Enter to continue..."
    read
}

# Access and usage help
show_access_help() {
    print_header "                    Access & Usage Help               "
    echo
    echo -e "${CYAN}🌐 Accessing Web UI Management${NC}"
    echo
    echo -e "${YELLOW}Web Interface URLs:${NC}"
    echo -e "  🏠 Local:   ${GREEN}http://localhost:8080${NC}"
    echo -e "  🌐 Network: ${GREEN}http://YOUR_IP:8080${NC}"
    echo
    echo -e "${YELLOW}Default Login Credentials:${NC}"
    echo -e "  👤 Username: ${GREEN}admin${NC}"
    echo -e "  🔑 Password: ${GREEN}admin123${NC}"
    echo
    echo -e "${YELLOW}Service Management Commands:${NC}"
    echo -e "  ▶️  Start:   ${GREEN}sudo systemctl start web-ui-mgmt${NC}"
    echo -e "  ⏹️  Stop:    ${GREEN}sudo systemctl stop web-ui-mgmt${NC}"
    echo -e "  📊 Status:  ${GREEN}sudo systemctl status web-ui-mgmt${NC}"
    echo -e "  📋 Logs:    ${GREEN}sudo journalctl -u web-ui-mgmt -f${NC}"
    echo -e "  🔄 Restart: ${GREEN}sudo systemctl restart web-ui-mgmt${NC}"
    echo
    echo -e "${YELLOW}Features:${NC}"
    echo -e "  🛡️ Firewall rules management"
    echo -e "  🛣️ Routing table management"
    echo -e "  📊 System information dashboard"
    echo -e "  🔐 JWT-based authentication"
    echo -e "  📱 Responsive design"
    echo
    print_question "Press Enter to continue..."
    read
}

# Scripts overview
show_scripts_overview() {
    print_header "                    All Scripts Overview              "
    echo
    echo -e "${CYAN}📋 Available Scripts${NC}"
    echo
    echo -e "${YELLOW}1. install.sh${NC}"
    echo -e "   Purpose: ${GREEN}Interactive installation${NC}"
    echo -e "   Usage:   ${GREEN}./install.sh${NC}"
    echo -e "   Questions: 6 (path, username, password, port, bind, service)"
    echo
    echo -e "${YELLOW}2. uninstall.sh${NC}"
    echo -e "   Purpose: ${GREEN}Complete removal${NC}"
    echo -e "   Usage:   ${GREEN}./uninstall.sh${NC}"
    echo -e "   Questions: 3 (service, path, port)"
    echo
    echo -e "${YELLOW}3. update.sh${NC}"
    echo -e "   Purpose: ${GREEN}Seamless update${NC}"
    echo -e "   Usage:   ${GREEN}./update.sh${NC}"
    echo -e "   Questions: 2 (service, path)"
    echo
    echo -e "${YELLOW}4. create-package.sh${NC}"
    echo -e "   Purpose: ${GREEN}Create distribution package${NC}"
    echo -e "   Usage:   ${GREEN}./create-package.sh${NC}"
    echo -e "   Questions: 1 (version)"
    echo
    echo -e "${YELLOW}5. help.sh${NC}"
    echo -e "   Purpose: ${GREEN}Interactive help system${NC}"
    echo -e "   Usage:   ${GREEN}./help.sh${NC}"
    echo -e "   Questions: 0 (menu-driven)"
    echo
    echo -e "${YELLOW}6. start.sh${NC}"
    echo -e "   Purpose: ${GREEN}Manual start (no systemd)${NC}"
    echo -e "   Usage:   ${GREEN}sudo ./start.sh${NC}"
    echo -e "   Questions: 0 (direct execution)"
    echo
    echo -e "${YELLOW}7. test.sh${NC}"
    echo -e "   Purpose: ${GREEN}Test application functionality${NC}"
    echo -e "   Usage:   ${GREEN}./test.sh${NC}"
    echo -e "   Questions: 0 (direct execution)"
    echo
    echo -e "${YELLOW}8. demo.sh${NC}"
    echo -e "   Purpose: ${GREEN}Demonstrate application features${NC}"
    echo -e "   Usage:   ${GREEN}./demo.sh${NC}"
    echo -e "   Questions: 0 (direct execution)"
    echo
    print_question "Press Enter to continue..."
    read
}

# FAQ
show_faq() {
    print_header "                    Frequently Asked Questions        "
    echo
    echo -e "${CYAN}❓ Common Questions and Answers${NC}"
    echo
    echo -e "${YELLOW}Q: Can I change settings after installation?${NC}"
    echo -e "A: Yes! Edit ${GREEN}/opt/web-ui-mgmt/config.json${NC} and restart service"
    echo
    echo -e "${YELLOW}Q: How do I change the admin password?${NC}"
    echo -e "A: Edit config file and restart: ${GREEN}sudo systemctl restart web-ui-mgmt${NC}"
    echo
    echo -e "${YELLOW}Q: Can I run multiple instances?${NC}"
    echo -e "A: Yes, use different ports, service names, and installation directories"
    echo
    echo -e "${YELLOW}Q: How do I backup my configuration?${NC}"
    echo -e "A: ${GREEN}cp /opt/web-ui-mgmt/config.json /opt/web-ui-mgmt/config.json.backup${NC}"
    echo
    echo -e "${YELLOW}Q: Can I install without systemd?${NC}"
    echo -e "A: Yes, use manual installation: ${GREEN}make build && sudo ./start.sh${NC}"
    echo
    echo -e "${YELLOW}Q: How do I check if the service is running?${NC}"
    echo -e "A: ${GREEN}sudo systemctl status web-ui-mgmt${NC}"
    echo
    echo -e "${YELLOW}Q: Can I install on a different Linux distribution?${NC}"
    echo -e "A: Yes, but you may need to install Go manually and adjust commands"
    echo
    echo -e "${YELLOW}Q: What if I forget my installation settings?${NC}"
    echo -e "A: Check ${GREEN}/opt/web-ui-mgmt/config.json${NC} for your configuration"
    echo
    print_question "Press Enter to continue..."
    read
}

# Main loop
while true; do
    show_main_menu
    read -p "Choice: " choice
    
    case $choice in
        1)
            show_installation_help
            ;;
        2)
            show_uninstallation_help
            ;;
        3)
            show_update_help
            ;;
        4)
            show_package_help
            ;;
        5)
            show_troubleshooting_help
            ;;
        6)
            show_configuration_help
            ;;
        7)
            show_access_help
            ;;
        8)
            show_scripts_overview
            ;;
        9)
            show_faq
            ;;
        0)
            echo
            print_status "Thank you for using Web UI Management Help Center! 🚀"
            echo
            exit 0
            ;;
        *)
            print_error "Invalid choice. Please enter a number between 0-9."
            echo
            ;;
    esac
done
