package main

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/golang-jwt/jwt/v5"
)

// Configuration
type Config struct {
	Server struct {
		Host string `json:"host"`
		Port int    `json:"port"`
	} `json:"server"`
	Auth struct {
		Username string `json:"username"`
		Password string `json:"password"`
	} `json:"auth"`
	System struct {
		IptablesPath string `json:"iptables_path"`
		IpPath       string `json:"ip_path"`
	} `json:"system"`
	SecretKey   string `json:"secret_key"`
	RequireAuth bool   `json:"require_auth"`
}

// Authentication
type LoginRequest struct {
	Username string `json:"username"`
	Password string `json:"password"`
}

type Claims struct {
	Username string `json:"username"`
	jwt.RegisteredClaims
}

// Firewall Rules
type FirewallRule struct {
	ID          int    `json:"id"`
	Table       string `json:"table"`
	Chain       string `json:"chain"`
	Protocol    string `json:"protocol"`
	Source      string `json:"source"`
	Destination string `json:"destination"`
	Port        string `json:"port"`
	Action      string `json:"action"`
	Comment     string `json:"comment"`
	Raw         string `json:"raw"`
}

type FirewallRuleRequest struct {
	Table       string `json:"table"`
	Chain       string `json:"chain"`
	Protocol    string `json:"protocol"`
	Source      string `json:"source"`
	Destination string `json:"destination"`
	Port        string `json:"port"`
	Action      string `json:"action"`
	Comment     string `json:"comment"`
}

// Routing
type Route struct {
	ID        int    `json:"id"`
	Network   string `json:"network"`
	Gateway   string `json:"gateway"`
	Interface string `json:"interface"`
	Metric    string `json:"metric"`
	Raw       string `json:"raw"`
}

type RouteRequest struct {
	Network   string `json:"network"`
	Gateway   string `json:"gateway"`
	Interface string `json:"interface"`
	Metric    string `json:"metric"`
}

var config Config
var firewallRules []FirewallRule
var routes []Route

func main() {
	// Load configuration
	loadConfig()
	
	// Initialize data
	loadFirewallRules()
	loadRoutes()
	
	// Setup Gin router
	r := gin.Default()
	
	// CORS middleware
	r.Use(func(c *gin.Context) {
		c.Header("Access-Control-Allow-Origin", "*")
		c.Header("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS")
		c.Header("Access-Control-Allow-Headers", "Content-Type, Authorization")
		
		if c.Request.Method == "OPTIONS" {
			c.AbortWithStatus(204)
			return
		}
		
		c.Next()
	})
	
	// Authentication routes
	r.POST("/api/login", login)
	
	// Protected routes
	api := r.Group("/api")
	if config.RequireAuth {
		api.Use(authMiddleware())
	}
	
	// Firewall routes
	api.GET("/firewall/rules", getFirewallRules)
	api.POST("/firewall/rules", addFirewallRule)
	api.DELETE("/firewall/rules/:id", deleteFirewallRule)
	api.POST("/firewall/rules/reload", reloadFirewallRules)
	
	// Routing routes
	api.GET("/routes", getRoutes)
	api.POST("/routes", addRoute)
	api.DELETE("/routes/:id", deleteRoute)
	
	// System info
	api.GET("/system/info", getSystemInfo)
	
	// Serve static files
	// Get the directory where the binary is located
	execPath, err := os.Executable()
	if err != nil {
		log.Fatal("Failed to get executable path:", err)
	}
	execDir := filepath.Dir(execPath)
	frontendPath := filepath.Join(execDir, "..", "frontend")
	
	r.Static("/static", frontendPath)
	r.LoadHTMLGlob(filepath.Join(frontendPath, "*.html"))
	r.GET("/", func(c *gin.Context) {
		c.HTML(http.StatusOK, "index.html", nil)
	})
	
	log.Printf("Starting Web UI Management on port %d", config.Server.Port)
	log.Fatal(r.Run(fmt.Sprintf(":%d", config.Server.Port)))
}

func loadConfig() {
	// Default configuration
	config = Config{
		Server: struct {
			Host string `json:"host"`
			Port int    `json:"port"`
		}{
			Host: "0.0.0.0",
			Port: 8080,
		},
		Auth: struct {
			Username string `json:"username"`
			Password string `json:"password"`
		}{
			Username: "admin",
			Password: "admin123",
		},
		System: struct {
			IptablesPath string `json:"iptables_path"`
			IpPath       string `json:"ip_path"`
		}{
			IptablesPath: "/sbin/iptables",
			IpPath:       "/sbin/ip",
		},
		SecretKey:   "your-secret-key-change-this",
		RequireAuth: true,
	}
	
	// Try to load from config file
	if data, err := os.ReadFile("config.json"); err == nil {
		if err := json.Unmarshal(data, &config); err != nil {
			log.Printf("Error parsing config.json: %v", err)
		} else {
			log.Printf("Configuration loaded from config.json")
		}
	} else {
		log.Printf("config.json not found, using default configuration")
	}
}

func authMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		tokenString := c.GetHeader("Authorization")
		if tokenString == "" {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "Authorization header required"})
			c.Abort()
			return
		}
		
		// Remove "Bearer " prefix
		if strings.HasPrefix(tokenString, "Bearer ") {
			tokenString = tokenString[7:]
		}
		
		token, err := jwt.ParseWithClaims(tokenString, &Claims{}, func(token *jwt.Token) (interface{}, error) {
			return []byte(config.SecretKey), nil
		})
		
		if err != nil || !token.Valid {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid token"})
			c.Abort()
			return
		}
		
		c.Next()
	}
}

func login(c *gin.Context) {
	var req LoginRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	
	if req.Username != config.Auth.Username || req.Password != config.Auth.Password {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid credentials"})
		return
	}
	
	// Create JWT token
	claims := &Claims{
		Username: req.Username,
		RegisteredClaims: jwt.RegisteredClaims{
			ExpiresAt: jwt.NewNumericDate(time.Now().Add(24 * time.Hour)),
		},
	}
	
	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	tokenString, err := token.SignedString([]byte(config.SecretKey))
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to create token"})
		return
	}
	
	c.JSON(http.StatusOK, gin.H{"token": tokenString})
}

func loadFirewallRules() {
	firewallRules = []FirewallRule{}
	
	// Get iptables rules
	cmd := exec.Command("iptables-save")
	output, err := cmd.Output()
	if err != nil {
		log.Printf("Error getting iptables rules: %v", err)
		return
	}
	
	lines := strings.Split(string(output), "\n")
	id := 1
	
	for _, line := range lines {
		line = strings.TrimSpace(line)
		if strings.HasPrefix(line, "-A ") {
			parts := strings.Fields(line)
			if len(parts) >= 3 {
				rule := FirewallRule{
					ID:    id,
					Chain: parts[1],
					Raw:   line,
				}
				
				// Parse rule components
				for i := 2; i < len(parts); i++ {
					switch parts[i] {
					case "-p":
						if i+1 < len(parts) {
							rule.Protocol = parts[i+1]
							i++
						}
					case "-s":
						if i+1 < len(parts) {
							rule.Source = parts[i+1]
							i++
						}
					case "-d":
						if i+1 < len(parts) {
							rule.Destination = parts[i+1]
							i++
						}
					case "--dport":
						if i+1 < len(parts) {
							rule.Port = parts[i+1]
							i++
						}
					case "-j":
						if i+1 < len(parts) {
							rule.Action = parts[i+1]
							i++
						}
					case "-m", "comment", "--comment":
						if i+1 < len(parts) {
							rule.Comment = parts[i+1]
							i++
						}
					}
				}
				
				firewallRules = append(firewallRules, rule)
				id++
			}
		}
	}
}

func loadRoutes() {
	routes = []Route{}
	
	// Get routing table
	cmd := exec.Command("ip", "route", "show")
	output, err := cmd.Output()
	if err != nil {
		log.Printf("Error getting routes: %v", err)
		return
	}
	
	lines := strings.Split(string(output), "\n")
	id := 1
	
	for _, line := range lines {
		line = strings.TrimSpace(line)
		if line == "" {
			continue
		}
		
		parts := strings.Fields(line)
		if len(parts) >= 3 {
			route := Route{
				ID:  id,
				Raw: line,
			}
			
			// Parse route components
			for i := 0; i < len(parts); i++ {
				switch parts[i] {
				case "via":
					if i+1 < len(parts) {
						route.Gateway = parts[i+1]
						i++
					}
				case "dev":
					if i+1 < len(parts) {
						route.Interface = parts[i+1]
						i++
					}
				case "metric":
					if i+1 < len(parts) {
						route.Metric = parts[i+1]
						i++
					}
				default:
					if route.Network == "" && !strings.Contains(parts[i], "via") && !strings.Contains(parts[i], "dev") {
						route.Network = parts[i]
					}
				}
			}
			
			routes = append(routes, route)
			id++
		}
	}
}

// Save firewall rules to make them persistent
func saveFirewallRules() error {
	cmd := exec.Command("iptables-save")
	output, err := cmd.Output()
	if err != nil {
		return fmt.Errorf("failed to get iptables rules: %v", err)
	}
	
	// Save to /etc/iptables/rules.v4 (Ubuntu/Debian) or /etc/sysconfig/iptables (CentOS/RHEL)
	// Try Ubuntu/Debian first
	if err := os.MkdirAll("/etc/iptables", 0755); err == nil {
		if err := os.WriteFile("/etc/iptables/rules.v4", output, 0644); err == nil {
			log.Println("Firewall rules saved to /etc/iptables/rules.v4")
			return nil
		}
	}
	
	// Try CentOS/RHEL
	if err := os.WriteFile("/etc/sysconfig/iptables", output, 0644); err == nil {
		log.Println("Firewall rules saved to /etc/sysconfig/iptables")
		return nil
	}
	
	return fmt.Errorf("failed to save firewall rules to any standard location")
}

// Save routes to make them persistent
func saveRoutes() error {
	cmd := exec.Command("ip", "route", "show")
	output, err := cmd.Output()
	if err != nil {
		return fmt.Errorf("failed to get routes: %v", err)
	}
	
	// Save to /etc/network/routes (Ubuntu/Debian) or /etc/sysconfig/static-routes (CentOS/RHEL)
	// Try Ubuntu/Debian first
	if err := os.WriteFile("/etc/network/routes", output, 0644); err == nil {
		log.Println("Routes saved to /etc/network/routes")
		return nil
	}
	
	// Try CentOS/RHEL
	if err := os.WriteFile("/etc/sysconfig/static-routes", output, 0644); err == nil {
		log.Println("Routes saved to /etc/sysconfig/static-routes")
		return nil
	}
	
	return fmt.Errorf("failed to save routes to any standard location")
}

func getFirewallRules(c *gin.Context) {
	c.JSON(http.StatusOK, gin.H{"rules": firewallRules})
}

func addFirewallRule(c *gin.Context) {
	var req FirewallRuleRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	
	// Build iptables command
	args := []string{"-t", req.Table, "-A", req.Chain}
	
	if req.Protocol != "" {
		args = append(args, "-p", req.Protocol)
	}
	if req.Source != "" {
		args = append(args, "-s", req.Source)
	}
	if req.Destination != "" {
		args = append(args, "-d", req.Destination)
	}
	if req.Port != "" {
		args = append(args, "-p", req.Protocol, "--dport", req.Port)
	}
	if req.Comment != "" {
		args = append(args, "-m", "comment", "--comment", req.Comment)
	}
	args = append(args, "-j", req.Action)
	
	// Execute iptables command
	cmd := exec.Command("iptables", args...)
	if err := cmd.Run(); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": fmt.Sprintf("Failed to add rule: %v", err)})
		return
	}
	
	// Save rules to make them persistent
	if err := saveFirewallRules(); err != nil {
		log.Printf("Warning: Failed to save firewall rules: %v", err)
	}
	
	// Reload rules
	loadFirewallRules()
	c.JSON(http.StatusOK, gin.H{"message": "Rule added successfully"})
}

func deleteFirewallRule(c *gin.Context) {
	id := c.Param("id")
	
	// Find rule by ID
	var rule *FirewallRule
	for _, r := range firewallRules {
		if fmt.Sprintf("%d", r.ID) == id {
			rule = &r
			break
		}
	}
	
	if rule == nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Rule not found"})
		return
	}
	
	// Build delete command
	args := []string{"-t", "filter", "-D", rule.Chain}
	
	// Parse the raw rule to extract parameters
	parts := strings.Fields(rule.Raw)
	for i := 2; i < len(parts); i++ {
		if parts[i] == "-j" {
			break
		}
		args = append(args, parts[i])
		if i+1 < len(parts) && parts[i+1] != "-j" && !strings.HasPrefix(parts[i+1], "-") {
			args = append(args, parts[i+1])
			i++
		}
	}
	
	// Execute delete command
	cmd := exec.Command("iptables", args...)
	if err := cmd.Run(); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": fmt.Sprintf("Failed to delete rule: %v", err)})
		return
	}
	
	// Reload rules
	loadFirewallRules()
	c.JSON(http.StatusOK, gin.H{"message": "Rule deleted successfully"})
}

func reloadFirewallRules(c *gin.Context) {
	loadFirewallRules()
	c.JSON(http.StatusOK, gin.H{"message": "Rules reloaded successfully"})
}

func getRoutes(c *gin.Context) {
	c.JSON(http.StatusOK, gin.H{"routes": routes})
}

func addRoute(c *gin.Context) {
	var req RouteRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	
	// Build ip route command
	args := []string{"route", "add", req.Network}
	
	if req.Gateway != "" {
		args = append(args, "via", req.Gateway)
	}
	if req.Interface != "" {
		args = append(args, "dev", req.Interface)
	}
	if req.Metric != "" {
		args = append(args, "metric", req.Metric)
	}
	
	// Execute ip route command
	cmd := exec.Command("ip", args...)
	if err := cmd.Run(); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": fmt.Sprintf("Failed to add route: %v", err)})
		return
	}
	
	// Save routes to make them persistent
	if err := saveRoutes(); err != nil {
		log.Printf("Warning: Failed to save routes: %v", err)
	}
	
	// Reload routes
	loadRoutes()
	c.JSON(http.StatusOK, gin.H{"message": "Route added successfully"})
}

func deleteRoute(c *gin.Context) {
	id := c.Param("id")
	
	// Find route by ID
	var route *Route
	for _, r := range routes {
		if fmt.Sprintf("%d", r.ID) == id {
			route = &r
			break
		}
	}
	
	if route == nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Route not found"})
		return
	}
	
	// Build delete command
	args := []string{"route", "del"}
	
	// Parse the raw route to extract network
	parts := strings.Fields(route.Raw)
	if len(parts) > 0 {
		args = append(args, parts[0]) // network
	}
	
	// Execute delete command
	cmd := exec.Command("ip", args...)
	if err := cmd.Run(); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": fmt.Sprintf("Failed to delete route: %v", err)})
		return
	}
	
	// Reload routes
	loadRoutes()
	c.JSON(http.StatusOK, gin.H{"message": "Route deleted successfully"})
}

func getSystemInfo(c *gin.Context) {
	// Get system information
	hostname, _ := exec.Command("hostname").Output()
	uptime, _ := exec.Command("uptime").Output()
	
	info := gin.H{
		"hostname": strings.TrimSpace(string(hostname)),
		"uptime":   strings.TrimSpace(string(uptime)),
		"rules_count": len(firewallRules),
		"routes_count": len(routes),
	}
	
	c.JSON(http.StatusOK, info)
}
