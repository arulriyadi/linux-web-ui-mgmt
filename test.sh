#!/bin/bash

# Test script for Web UI Management

echo "🧪 Testing Web UI Management..."

# Test 1: Check if binary exists and is executable
echo "Test 1: Binary check"
if [ -f "./backend/web-ui-mgmt" ]; then
    echo "✅ Binary exists"
    if [ -x "./backend/web-ui-mgmt" ]; then
        echo "✅ Binary is executable"
    else
        echo "❌ Binary is not executable"
        exit 1
    fi
else
    echo "❌ Binary not found"
    exit 1
fi

# Test 2: Check if frontend files exist
echo "Test 2: Frontend files check"
if [ -f "./frontend/index.html" ]; then
    echo "✅ Frontend HTML exists"
else
    echo "❌ Frontend HTML not found"
    exit 1
fi

# Test 3: Check if config file exists
echo "Test 3: Configuration check"
if [ -f "./config.json" ]; then
    echo "✅ Config file exists"
    if python3 -m json.tool config.json > /dev/null 2>&1; then
        echo "✅ Config file is valid JSON"
    else
        echo "❌ Config file is not valid JSON"
        exit 1
    fi
else
    echo "❌ Config file not found"
    exit 1
fi

# Test 4: Check if Docker files exist
echo "Test 4: Docker files check"
if [ -f "./docker/Dockerfile" ]; then
    echo "✅ Dockerfile exists"
else
    echo "❌ Dockerfile not found"
    exit 1
fi

if [ -f "./docker/docker-compose.yml" ]; then
    echo "✅ Docker Compose file exists"
else
    echo "❌ Docker Compose file not found"
    exit 1
fi

# Test 5: Check system dependencies
echo "Test 5: System dependencies check"
if command -v iptables &> /dev/null; then
    echo "✅ iptables command available"
else
    echo "❌ iptables command not found"
    exit 1
fi

if command -v ip &> /dev/null; then
    echo "✅ ip command available"
else
    echo "❌ ip command not found"
    exit 1
fi

# Test 6: Test application startup (briefly)
echo "Test 6: Application startup test"
timeout 5s ./backend/web-ui-mgmt &
APP_PID=$!
sleep 2

if kill -0 $APP_PID 2>/dev/null; then
    echo "✅ Application started successfully"
    kill $APP_PID
else
    echo "❌ Application failed to start"
    exit 1
fi

echo ""
echo "🎉 All tests passed! The Web UI Management application is ready to use."
echo ""
echo "To start the application:"
echo "  sudo ./start.sh"
echo ""
echo "Or with Docker:"
echo "  docker-compose -f docker/docker-compose.yml up -d"
echo ""
echo "Access the web interface at: http://localhost:8080"
echo "Default login: admin / admin123"
