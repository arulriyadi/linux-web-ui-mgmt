# 🚀 Web UI Management - Quick Reference

**Fast installation and management guide**

---

## 📥 **Quick Installation**

```bash
# Download and install
wget https://github.com/your-repo/web-ui-mgmt/releases/latest/download/web-ui-mgmt-latest.tar.gz
tar -xzf web-ui-mgmt-latest.tar.gz
cd web-ui-mgmt-*
./install.sh
```

**Just press Enter for all defaults:**
- Installation path: `/opt/web-ui-mgmt`
- Username: `admin`
- Password: `admin123`
- Port: `8080`
- Bind: `0.0.0.0`
- Service: `web-ui-mgmt`

---

## 🔧 **Management Commands**

| Action | Command |
|--------|---------|
| **Start** | `sudo systemctl start web-ui-mgmt` |
| **Stop** | `sudo systemctl stop web-ui-mgmt` |
| **Status** | `sudo systemctl status web-ui-mgmt` |
| **Logs** | `sudo journalctl -u web-ui-mgmt -f` |
| **Restart** | `sudo systemctl restart web-ui-mgmt` |
| **Enable** | `sudo systemctl enable web-ui-mgmt` |
| **Disable** | `sudo systemctl disable web-ui-mgmt` |

---

## 🌐 **Access**

- **Local:** http://localhost:8080
- **Network:** http://YOUR_IP:8080
- **Login:** admin / admin123

---

## 🛠️ **Scripts**

| Script | Purpose | Usage |
|--------|---------|-------|
| `install.sh` | Install | `./install.sh` |
| `uninstall.sh` | Remove | `./uninstall.sh` |
| `update.sh` | Update | `./update.sh` |
| `create-package.sh` | Create package | `./create-package.sh` |

---

## ⚙️ **Configuration**

**Edit config:**
```bash
sudo nano /opt/web-ui-mgmt/config.json
sudo systemctl restart web-ui-mgmt
```

**Change password:**
```json
{
  "auth": {
    "username": "admin",
    "password": "your-new-password"
  }
}
```

---

## 🔍 **Troubleshooting**

| Problem | Solution |
|---------|----------|
| **Permission denied** | `chmod +x *.sh` |
| **Port in use** | `sudo netstat -tlnp \| grep :8080` |
| **Service won't start** | `sudo journalctl -u web-ui-mgmt -f` |
| **Go not found** | `sudo apt install golang-go` |

---

## 📋 **Installation Questions**

### `install.sh` Questions:
1. **Installation path:** Where to install (default: `/opt/web-ui-mgmt`)
2. **Admin username:** Login username (default: `admin`)
3. **Admin password:** Login password (default: `admin123`)
4. **Web port:** Port number (default: `8080`)
5. **Bind address:** IP to bind (default: `0.0.0.0`)
6. **Service name:** Systemd service name (default: `web-ui-mgmt`)

### `uninstall.sh` Questions:
1. **Service name:** Name of service to remove
2. **Installation path:** Path to remove
3. **Web port:** Port to clean from firewall

### `update.sh` Questions:
1. **Service name:** Name of service to update
2. **Installation path:** Path to update

### `create-package.sh` Questions:
1. **Version:** Version number for package

---

## 🎯 **Quick Tips**

- ✅ **Always use defaults** for first installation
- ✅ **Change password** after installation
- ✅ **Use HTTPS** in production
- ✅ **Backup config** before updates
- ✅ **Check logs** if something goes wrong

---

**Need help? Check `MANUAL.md` for detailed instructions! 📚**
