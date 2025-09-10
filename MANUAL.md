# 📚 Web UI Management - Manual Book

**Complete Guide for Installation, Configuration, and Management**

---

## 🎯 **Table of Contents**

1. [Overview](#overview)
2. [Installation Scripts](#installation-scripts)
3. [Interactive Installer (`install.sh`)](#interactive-installer-installsh)
4. [Uninstaller (`uninstall.sh`)](#uninstaller-uninstallsh)
5. [Updater (`update.sh`)](#updater-updatesh)
6. [Package Creator (`create-package.sh`)](#package-creator-create-packagesh)
7. [Troubleshooting](#troubleshooting)
8. [FAQ](#faq)

---

## 📖 **Overview**

Web UI Management provides several interactive scripts to make installation, management, and maintenance as easy as possible. All scripts feature:

- 🎨 **Colored output** for better readability
- ❓ **Interactive prompts** with helpful defaults
- ✅ **Input validation** and error handling
- 🔄 **Progress indicators** and status messages
- 📋 **Summary confirmation** before execution

---

## 🛠️ **Installation Scripts**

### **Available Scripts:**

| Script | Purpose | When to Use |
|--------|---------|-------------|
| `install.sh` | Interactive installation | First-time setup |
| `uninstall.sh` | Complete removal | When you want to remove the application |
| `update.sh` | Update existing installation | When updating to newer version |
| `create-package.sh` | Create distribution package | For developers/distributors |

---

## 🚀 **Interactive Installer (`install.sh`)**

### **What it does:**
- Installs Web UI Management with custom settings
- Creates systemd service for auto-start
- Configures firewall rules
- Sets up proper permissions

### **Interactive Questions:**

#### **1. Installation Directory**
```
[?] Where would you like to install Web UI Management?
Default: /opt/web-ui-mgmt
Installation path: 
```
**What to enter:**
- **Default**: Just press Enter for `/opt/web-ui-mgmt`
- **Custom**: Enter your preferred path (e.g., `/home/user/web-ui-mgmt`, `/usr/local/web-ui-mgmt`)

**Examples:**
- `/opt/web-ui-mgmt` (recommended for system-wide)
- `/home/user/web-ui-mgmt` (for user-specific)
- `/usr/local/web-ui-mgmt` (alternative system location)

#### **2. Admin Username**
```
[?] What username would you like for admin access?
Default: admin
Admin username: 
```
**What to enter:**
- **Default**: Just press Enter for `admin`
- **Custom**: Enter your preferred username (e.g., `root`, `administrator`, `firewall-admin`)

**Examples:**
- `admin` (simple and common)
- `firewall-admin` (descriptive)
- `root` (if you prefer root access)

#### **3. Admin Password**
```
[?] What password would you like for admin access?
Default: admin123
Admin password: 
```
**What to enter:**
- **Default**: Just press Enter for `admin123`
- **Custom**: Enter a strong password (minimum 8 characters recommended)

**Password Requirements:**
- Minimum 6 characters
- Can contain letters, numbers, and symbols
- Will be hidden while typing (for security)

**Examples:**
- `admin123` (default, change in production!)
- `MySecurePass123!` (strong password)
- `Firewall2024#` (descriptive and secure)

#### **4. Web Port**
```
[?] What port would you like the web interface to run on?
Default: 8080
Port number: 
```
**What to enter:**
- **Default**: Just press Enter for `8080`
- **Custom**: Enter any available port (1024-65535)

**Common Ports:**
- `8080` (default, commonly used)
- `3000` (alternative web port)
- `8443` (HTTPS alternative)
- `9090` (another common web port)

**Port Requirements:**
- Must be between 1024-65535
- Must not be in use by other services
- Will be automatically checked

#### **5. Bind Address**
```
[?] Which IP address should the web interface bind to?
Options: 0.0.0.0 (all interfaces), 127.0.0.1 (localhost only), or specific IP
Default: 0.0.0.0
Bind address: 
```
**What to enter:**
- **Default**: Just press Enter for `0.0.0.0` (all interfaces)
- **Localhost only**: Enter `127.0.0.1`
- **Specific IP**: Enter your server's IP address

**Options Explained:**
- `0.0.0.0` - Accessible from any network interface (recommended for remote access)
- `127.0.0.1` - Only accessible from localhost (most secure)
- `192.168.1.100` - Only accessible from specific IP (if you know your server IP)

#### **6. Service Name**
```
[?] What would you like to name the systemd service?
Default: web-ui-mgmt
Service name: 
```
**What to enter:**
- **Default**: Just press Enter for `web-ui-mgmt`
- **Custom**: Enter your preferred service name

**Examples:**
- `web-ui-mgmt` (default)
- `firewall-manager` (descriptive)
- `iptables-web` (functional)

### **Installation Summary:**
After answering all questions, you'll see a summary:
```
═══════════════════════════════════════════════════════════════
                    Installation Summary                        
═══════════════════════════════════════════════════════════════
Installation Path: /opt/web-ui-mgmt
Admin Username:    admin
Admin Password:    admin123
Web Port:          8080
Bind Address:      0.0.0.0
Service Name:      web-ui-mgmt
═══════════════════════════════════════════════════════════════

[?] Do you want to proceed with the installation? (y/N)
```

**What to do:**
- Type `y` and press Enter to continue
- Type `n` and press Enter to cancel

### **What happens during installation:**
1. ✅ System packages updated
2. ✅ Dependencies installed (Go, curl, wget, unzip)
3. ✅ Installation directory created
4. ✅ Application files copied
5. ✅ Configuration file created
6. ✅ Application built
7. ✅ Permissions set
8. ✅ Systemd service created
9. ✅ Service enabled and started
10. ✅ Firewall rules configured
11. ✅ Service status verified

### **After Installation:**
```
🎉 Installation Complete! 🎉

Access your Web UI Management at:
  Local:   http://localhost:8080
  Network: http://192.168.1.100:8080

Login Credentials:
  Username: admin
  Password: admin123

Service Management:
  Start:   sudo systemctl start web-ui-mgmt
  Stop:    sudo systemctl stop web-ui-mgmt
  Status:  sudo systemctl status web-ui-mgmt
  Logs:    sudo journalctl -u web-ui-mgmt -f
```

---

## 🗑️ **Uninstaller (`uninstall.sh`)**

### **What it does:**
- Completely removes Web UI Management
- Stops and disables systemd service
- Removes all files and directories
- Cleans up firewall rules
- Terminates any running processes

### **Interactive Questions:**

#### **1. Service Name**
```
[?] What is the name of the Web UI Management service?
Default: web-ui-mgmt
Service name: 
```
**What to enter:**
- **Default**: Just press Enter if you used default during installation
- **Custom**: Enter the service name you used during installation

#### **2. Installation Directory**
```
[?] Where is Web UI Management installed?
Default: /opt/web-ui-mgmt
Installation path: 
```
**What to enter:**
- **Default**: Just press Enter if you used default during installation
- **Custom**: Enter the installation path you used during installation

#### **3. Web Port**
```
[?] What port was the web interface running on?
Default: 8080
Port number: 
```
**What to enter:**
- **Default**: Just press Enter if you used default during installation
- **Custom**: Enter the port you used during installation

### **Uninstallation Summary:**
```
═══════════════════════════════════════════════════════════════
                    Uninstallation Summary                     
═══════════════════════════════════════════════════════════════
Service Name:      web-ui-mgmt
Installation Path: /opt/web-ui-mgmt
Web Port:          8080
═══════════════════════════════════════════════════════════════

⚠️  This will completely remove Web UI Management from your system!
[?] Are you sure you want to proceed? (y/N)
```

**What to do:**
- Type `y` and press Enter to proceed with removal
- Type `n` and press Enter to cancel

### **What happens during uninstallation:**
1. ✅ Service stopped
2. ✅ Service disabled
3. ✅ Service file removed
4. ✅ Firewall rules removed
5. ✅ Installation directory removed
6. ✅ Running processes terminated
7. ✅ System cleaned up

---

## 🔄 **Updater (`update.sh`)**

### **What it does:**
- Updates existing Web UI Management installation
- Backs up current configuration
- Pulls latest changes (if git repository)
- Rebuilds application
- Restarts service

### **Interactive Questions:**

#### **1. Service Name**
```
[?] What is the name of the Web UI Management service?
Default: web-ui-mgmt
Service name: 
```
**What to enter:**
- **Default**: Just press Enter if you used default during installation
- **Custom**: Enter the service name you used during installation

#### **2. Installation Directory**
```
[?] Where is Web UI Management installed?
Default: /opt/web-ui-mgmt
Installation path: 
```
**What to enter:**
- **Default**: Just press Enter if you used default during installation
- **Custom**: Enter the installation path you used during installation

### **What happens during update:**
1. ✅ Current configuration backed up
2. ✅ Service stopped
3. ✅ Latest changes pulled (if git repo)
4. ✅ Application rebuilt
5. ✅ Permissions set
6. ✅ Configuration restored
7. ✅ Service started
8. ✅ Service status verified

### **After Update:**
```
🎉 Update Complete! 🎉

Access your updated Web UI Management at:
  Local:   http://localhost:8080
  Network: http://192.168.1.100:8080

Service Management:
  Status:  sudo systemctl status web-ui-mgmt
  Logs:    sudo journalctl -u web-ui-mgmt -f
```

---

## 📦 **Package Creator (`create-package.sh`)**

### **What it does:**
- Creates distribution packages for Web UI Management
- Generates tar.gz and zip files
- Creates documentation and changelog
- Prepares files for distribution

### **Interactive Questions:**

#### **1. Version Number**
```
[?] What version is this release?
Default: 1.0.0
Version: 
```
**What to enter:**
- **Default**: Just press Enter for `1.0.0`
- **Custom**: Enter version number (e.g., `1.2.3`, `2.0.0-beta`)

**Version Format:**
- Use semantic versioning: `MAJOR.MINOR.PATCH`
- Examples: `1.0.0`, `1.1.0`, `2.0.0`, `1.0.0-beta`

### **What happens during package creation:**
1. ✅ Distribution directory created
2. ✅ Application files copied
3. ✅ Installation scripts copied
4. ✅ Permissions set
5. ✅ Package info created
6. ✅ Changelog generated
7. ✅ README created
8. ✅ Tar.gz package created
9. ✅ Zip package created

### **After Package Creation:**
```
🎉 Package Created Successfully! 🎉

Package Information:
  Name:     web-ui-mgmt-1.0.0
  Version:  1.0.0
  Date:     Mon Jan 15 10:30:45 UTC 2024

Package Files:
  Directory: dist/web-ui-mgmt-1.0.0/
  Tar.gz:    dist/web-ui-mgmt-1.0.0.tar.gz (2.5M)
  Zip:       dist/web-ui-mgmt-1.0.0.zip (2.8M)

Installation Instructions:
  1. Extract the package: tar -xzf web-ui-mgmt-1.0.0.tar.gz
  2. Enter directory:     cd web-ui-mgmt-1.0.0
  3. Run installer:       ./install.sh
```

---

## 🔧 **Troubleshooting**

### **Common Issues and Solutions:**

#### **1. Permission Denied**
**Error:** `Permission denied` when running scripts
**Solution:**
```bash
chmod +x *.sh
```

#### **2. Service Won't Start**
**Error:** Service fails to start after installation
**Solution:**
```bash
sudo journalctl -u web-ui-mgmt -f
sudo systemctl status web-ui-mgmt
```

#### **3. Port Already in Use**
**Error:** Port 8080 is already in use
**Solution:**
```bash
sudo netstat -tlnp | grep :8080
sudo kill -9 <PID>
# Or use a different port during installation
```

#### **4. Go Not Found**
**Error:** `go: command not found`
**Solution:**
```bash
sudo apt update
sudo apt install golang-go
```

#### **5. Sudo Required**
**Error:** Script requires sudo privileges
**Solution:**
- Make sure you're in the sudo group: `sudo usermod -aG sudo $USER`
- Log out and log back in
- Or run with explicit sudo: `sudo ./install.sh`

### **Log Locations:**
- **Service logs:** `sudo journalctl -u web-ui-mgmt -f`
- **Application logs:** Check the terminal where you ran the script
- **System logs:** `/var/log/syslog`

---

## ❓ **FAQ**

### **Q: Can I change settings after installation?**
**A:** Yes! Edit the configuration file at your installation directory:
```bash
sudo nano /opt/web-ui-mgmt/config.json
sudo systemctl restart web-ui-mgmt
```

### **Q: How do I change the admin password?**
**A:** Edit the config file and restart the service:
```bash
sudo nano /opt/web-ui-mgmt/config.json
# Change the "password" field
sudo systemctl restart web-ui-mgmt
```

### **Q: Can I run multiple instances?**
**A:** Yes, but you need to:
- Use different ports
- Use different service names
- Use different installation directories

### **Q: How do I backup my configuration?**
**A:** The installer automatically backs up config during updates. Manual backup:
```bash
cp /opt/web-ui-mgmt/config.json /opt/web-ui-mgmt/config.json.backup
```

### **Q: Can I install without systemd?**
**A:** Yes, use manual installation:
```bash
make build
sudo ./start.sh
```

### **Q: How do I check if the service is running?**
**A:** Use systemctl:
```bash
sudo systemctl status web-ui-mgmt
sudo systemctl is-active web-ui-mgmt
```

### **Q: Can I install on a different Linux distribution?**
**A:** Yes, but you may need to:
- Install Go manually
- Use different package manager commands
- Adjust systemd service file if needed

---

## 📞 **Support**

If you encounter issues not covered in this manual:

1. **Check the logs:** `sudo journalctl -u web-ui-mgmt -f`
2. **Verify service status:** `sudo systemctl status web-ui-mgmt`
3. **Check configuration:** `cat /opt/web-ui-mgmt/config.json`
4. **Review this manual** for troubleshooting steps
5. **Contact support** with detailed error information

---

**Happy managing your firewall and routing! 🚀**
