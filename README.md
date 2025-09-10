# Web UI Management - iptables & Routing

A lightweight web interface for managing iptables firewall rules and routing tables on Linux systems.

## Features

- 🔥 **Firewall Management**: View, add, and delete iptables rules
- 🌐 **Routing Management**: Manage static routes with ip route commands
- 🔐 **Authentication**: JWT-based authentication system
- 📱 **Modern UI**: Clean, responsive interface built with Tailwind CSS
- 🐳 **Docker Ready**: Easy deployment with Docker
- ⚡ **Lightweight**: Built with Go for performance and small binary size

## Architecture

This is a "thin web panel" that provides a web frontend + lightweight backend that executes system commands:

- **Backend**: Go with Gin framework
- **Frontend**: HTML/CSS/JavaScript with Alpine.js and Tailwind CSS
- **Authentication**: JWT tokens
- **System Integration**: Direct execution of `iptables` and `ip route` commands

## 🚀 Quick Start

### Interactive Installation (Recommended)

1. **Download and extract**:
   ```bash
   wget https://github.com/your-repo/web-ui-mgmt/releases/latest/download/web-ui-mgmt-latest.tar.gz
   tar -xzf web-ui-mgmt-latest.tar.gz
   cd web-ui-mgmt-*
   ```

2. **Run the installer**:
   ```bash
   ./install.sh
   ```

   The installer will ask you for:
   - 📁 Installation directory (default: `/opt/web-ui-mgmt`)
   - 👤 Admin username (default: `admin`)
   - 🔑 Admin password (default: `admin123`)
   - 🌐 Web port (default: `8080`)
   - 🔗 Bind address (default: `0.0.0.0`)
   - ⚙️ Service name (default: `web-ui-mgmt`)

3. **Access the web interface**:
   - Open http://localhost:8080
   - Login with your configured credentials

### Using Docker (Alternative)

1. **Clone and build**:
   ```bash
   git clone <your-repo>
   cd web-ui-mgmt
   docker-compose -f docker/docker-compose.yml up -d
   ```

2. **Access the web interface**:
   - Open http://localhost:8080
   - Login with: `admin` / `admin123`

### Manual Installation

1. **Prerequisites**:
   ```bash
   # Install Go (if not already installed)
   sudo apt update
   sudo apt install golang-go
   
   # Ensure iptables and iproute2 are available
   sudo apt install iptables iproute2
   ```

2. **Build and run**:
   ```bash
   cd backend
   go mod download
   go build -o web-ui-mgmt main.go
   sudo ./web-ui-mgmt
   ```

## 🔧 Management Commands

### Service Control
```bash
sudo systemctl start web-ui-mgmt    # Start service
sudo systemctl stop web-ui-mgmt     # Stop service
sudo systemctl status web-ui-mgmt   # Check status
sudo journalctl -u web-ui-mgmt -f   # View logs
```

### Uninstallation
```bash
./uninstall.sh
```

### Update
```bash
./update.sh
```

## Configuration

Edit `config.json` to customize:

```json
{
  "port": "8080",
  "secret_key": "your-secret-key-change-this-in-production",
  "admin_user": "admin",
  "admin_pass": "admin123",
  "require_auth": true
}
```

## Security Considerations

⚠️ **Important Security Notes**:

1. **Change default credentials** in production
2. **Use HTTPS** in production (reverse proxy recommended)
3. **Restrict network access** (firewall, VPN, etc.)
4. **Regular backups** of iptables rules
5. **Monitor access logs**

### Recommended Production Setup

Use a reverse proxy like Nginx or Caddy:

```nginx
# Nginx example
server {
    listen 443 ssl;
    server_name your-domain.com;
    
    ssl_certificate /path/to/cert.pem;
    ssl_certificate_key /path/to/key.pem;
    
    location / {
        proxy_pass http://localhost:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

## Usage

### Firewall Rules

- **View Rules**: See all current iptables rules in a table
- **Add Rule**: Use the form to add new rules with protocol, source, destination, port, and action
- **Delete Rule**: Remove rules by clicking the delete button
- **Reload**: Refresh the rules list from the system

### Routing Table

- **View Routes**: Display current routing table
- **Add Route**: Add static routes with network, gateway, interface, and metric
- **Delete Route**: Remove routes from the system

## API Endpoints

### Authentication
- `POST /api/login` - Login and get JWT token

### Firewall
- `GET /api/firewall/rules` - Get all firewall rules
- `POST /api/firewall/rules` - Add new firewall rule
- `DELETE /api/firewall/rules/:id` - Delete firewall rule
- `POST /api/firewall/rules/reload` - Reload firewall rules

### Routing
- `GET /api/routes` - Get all routes
- `POST /api/routes` - Add new route
- `DELETE /api/routes/:id` - Delete route

### System
- `GET /api/system/info` - Get system information

## Development

### Project Structure

```
web-ui-mgmt/
├── backend/
│   ├── main.go          # Go backend server
│   └── go.mod           # Go dependencies
├── frontend/
│   └── index.html       # Web interface
├── docker/
│   ├── Dockerfile       # Container build
│   └── docker-compose.yml
├── config.json          # Configuration
└── README.md           # This file
```

### Building from Source

```bash
# Backend
cd backend
go mod download
go build -o web-ui-mgmt main.go

# Frontend (no build step needed - static HTML)
# Just serve the frontend/index.html file
```

### Development Workflow

For faster development without uninstalling/reinstalling, use these scripts:

#### 🚀 Interactive Development Menu
```bash
./dev-workflow.sh
```
This provides an interactive menu with all development options.

#### 🔥 Hot Reload Mode
```bash
./hot-reload.sh
```
Automatically copies frontend changes to the installation directory when you save files.

#### 🚀 Development Mode
```bash
./dev-mode.sh
```
Runs the application directly without systemd service (useful for debugging).

#### ⚡ Quick Restart
```bash
./quick-restart.sh
```
Restarts the service without rebuilding (fastest option).

#### 🔄 Full Update
```bash
./dev-update.sh
```
Rebuilds backend, updates frontend, and restarts service.

#### Development Commands Summary
- **Frontend changes**: Use `./hot-reload.sh` for automatic updates
- **Backend changes**: Use `./dev-update.sh` to rebuild and restart
- **Quick restart**: Use `./quick-restart.sh` for service restart only
- **Debug mode**: Use `./dev-mode.sh` to run without service
- **Interactive**: Use `./dev-workflow.sh` for menu-driven development

## Troubleshooting

### Common Issues

1. **Permission Denied**: Run with `sudo` or ensure proper capabilities
2. **Port Already in Use**: Change port in config.json
3. **iptables Command Not Found**: Install iptables package
4. **Docker Privileges**: Ensure container has `--privileged` flag

### Logs

Check application logs:
```bash
# Docker
docker logs web-ui-mgmt

# Manual
sudo ./web-ui-mgmt
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

MIT License - see LICENSE file for details.

## Disclaimer

⚠️ **Use at your own risk**. This tool directly modifies system firewall and routing rules. Always:
- Test in a safe environment first
- Backup your current configuration
- Have a recovery plan
- Monitor system behavior after changes

## Similar Projects

- [wg-dashboard](https://github.com/donaldzou/wg-dashboard) - WireGuard dashboard
- [uptime-kuma](https://github.com/louislam/uptime-kuma) - Uptime monitoring
- [firewalld](https://firewalld.org/) - Dynamic firewall daemon
