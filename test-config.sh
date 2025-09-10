#!/bin/bash

# Test Configuration Script
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

print_header "                    Configuration Test                        "

# Check if config.json exists
if [ -f "config.json" ]; then
    print_status "config.json found!"
    echo
    print_status "Current configuration:"
    cat config.json | jq . 2>/dev/null || cat config.json
    echo
else
    print_error "config.json not found!"
    exit 1
fi

# Test port configuration
PORT=$(grep -o '"port": [0-9]*' config.json | grep -o '[0-9]*')
print_status "Configured port: $PORT"

# Test username/password
USERNAME=$(grep -o '"username": "[^"]*"' config.json | cut -d'"' -f4)
PASSWORD=$(grep -o '"password": "[^"]*"' config.json | cut -d'"' -f4)
print_status "Configured username: $USERNAME"
print_status "Configured password: $PASSWORD"

# Check if service is running
if systemctl is-active --quiet web-ui-mgmt; then
    print_status "Service is running"
    
    # Check what port it's actually listening on
    ACTUAL_PORT=$(netstat -tlnp | grep web-ui-mgmt | awk '{print $4}' | cut -d':' -f2)
    print_status "Service is listening on port: $ACTUAL_PORT"
    
    if [ "$PORT" = "$ACTUAL_PORT" ]; then
        print_status "✅ Port configuration matches!"
    else
        print_warning "❌ Port mismatch! Configured: $PORT, Actual: $ACTUAL_PORT"
    fi
else
    print_warning "Service is not running"
fi

print_header "                    Test Complete                              "

