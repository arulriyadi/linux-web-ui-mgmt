#!/bin/bash

# Load Firewall Rules and Routes on Boot
# This script should be run at system startup

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Load firewall rules
load_firewall_rules() {
    print_status "Loading firewall rules..."
    
    # Try Ubuntu/Debian first
    if [ -f "/etc/iptables/rules.v4" ]; then
        print_status "Found iptables rules at /etc/iptables/rules.v4"
        if iptables-restore < /etc/iptables/rules.v4; then
            print_status "Firewall rules loaded successfully"
        else
            print_error "Failed to load firewall rules"
            return 1
        fi
    # Try CentOS/RHEL
    elif [ -f "/etc/sysconfig/iptables" ]; then
        print_status "Found iptables rules at /etc/sysconfig/iptables"
        if iptables-restore < /etc/sysconfig/iptables; then
            print_status "Firewall rules loaded successfully"
        else
            print_error "Failed to load firewall rules"
            return 1
        fi
    else
        print_warning "No firewall rules file found"
    fi
}

# Load routes
load_routes() {
    print_status "Loading routes..."
    
    # Try Ubuntu/Debian first
    if [ -f "/etc/network/routes" ]; then
        print_status "Found routes at /etc/network/routes"
        while IFS= read -r line; do
            line=$(echo "$line" | xargs) # trim whitespace
            if [ -n "$line" ] && [ "${line:0:1}" != "#" ]; then
                if ip route add $line 2>/dev/null; then
                    print_status "Added route: $line"
                else
                    print_warning "Failed to add route: $line (may already exist)"
                fi
            fi
        done < /etc/network/routes
    # Try CentOS/RHEL
    elif [ -f "/etc/sysconfig/static-routes" ]; then
        print_status "Found routes at /etc/sysconfig/static-routes"
        while IFS= read -r line; do
            line=$(echo "$line" | xargs) # trim whitespace
            if [ -n "$line" ] && [ "${line:0:1}" != "#" ]; then
                if ip route add $line 2>/dev/null; then
                    print_status "Added route: $line"
                else
                    print_warning "Failed to add route: $line (may already exist)"
                fi
            fi
        done < /etc/sysconfig/static-routes
    else
        print_warning "No routes file found"
    fi
}

# Main execution
main() {
    print_status "Starting Web UI Management rules loader..."
    
    # Load firewall rules
    load_firewall_rules
    
    # Load routes
    load_routes
    
    print_status "Rules loading completed"
}

# Run main function
main "$@"
