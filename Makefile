# Web UI Management Makefile

.PHONY: build run docker-build docker-run clean install test

# Build the Go application
build:
	cd backend && go mod download && go build -o web-ui-mgmt main.go

# Run the application (requires sudo)
run: build
	sudo ./backend/web-ui-mgmt

# Build Docker image
docker-build:
	docker build -f docker/Dockerfile -t web-ui-mgmt .

# Run with Docker Compose
docker-run:
	docker-compose -f docker/docker-compose.yml up -d

# Stop Docker Compose
docker-stop:
	docker-compose -f docker/docker-compose.yml down

# Clean build artifacts
clean:
	rm -f backend/web-ui-mgmt
	docker rmi web-ui-mgmt 2>/dev/null || true

# Install dependencies (Ubuntu/Debian)
install:
	sudo apt update
	sudo apt install -y golang-go iptables iproute2 docker.io docker-compose

# Test the application
test:
	cd backend && go test ./...

# Development mode (with auto-reload)
dev:
	cd backend && go run main.go

# Show logs
logs:
	docker logs web-ui-mgmt

# Help
help:
	@echo "Available targets:"
	@echo "  build       - Build the Go application"
	@echo "  run         - Run the application (requires sudo)"
	@echo "  docker-build- Build Docker image"
	@echo "  docker-run  - Run with Docker Compose"
	@echo "  docker-stop - Stop Docker Compose"
	@echo "  clean       - Clean build artifacts"
	@echo "  install     - Install dependencies"
	@echo "  test        - Run tests"
	@echo "  dev         - Development mode"
	@echo "  logs        - Show Docker logs"
	@echo "  help        - Show this help"
