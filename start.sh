#!/bin/bash

# Web UI Management Startup Script

echo "🚀 Starting Web UI Management..."

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo "❌ Please run as root (use sudo)"
    exit 1
fi

# Check if iptables is available
if ! command -v iptables &> /dev/null; then
    echo "❌ iptables not found. Please install iptables."
    exit 1
fi

# Check if ip command is available
if ! command -v ip &> /dev/null; then
    echo "❌ ip command not found. Please install iproute2."
    exit 1
fi

# Check if Go is installed (for manual build)
if [ ! -f "./backend/web-ui-mgmt" ]; then
    if command -v go &> /dev/null; then
        echo "🔨 Building application..."
        cd backend
        go mod download
        go build -o web-ui-mgmt main.go
        cd ..
    else
        echo "❌ Go not found and binary not built. Please install Go or use Docker."
        exit 1
    fi
fi

# Create config directory
mkdir -p /etc/web-ui-mgmt

# Copy config if it doesn't exist
if [ ! -f "/etc/web-ui-mgmt/config.json" ]; then
    cp config.json /etc/web-ui-mgmt/
    echo "📝 Created default config at /etc/web-ui-mgmt/config.json"
fi

# Start the application
echo "🌐 Starting Web UI Management on port 8080..."
echo "📱 Access the interface at: http://localhost:8080"
echo "🔐 Default login: admin / admin123"
echo ""
echo "Press Ctrl+C to stop"

cd backend
./web-ui-mgmt
