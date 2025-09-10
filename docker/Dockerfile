# Build stage
FROM golang:1.21-alpine AS builder

WORKDIR /app

# Install dependencies
RUN apk add --no-cache git

# Copy go mod files
COPY backend/go.mod backend/go.sum ./

# Download dependencies
RUN go mod download

# Copy source code
COPY backend/ ./

# Build the application
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o main .

# Final stage
FROM alpine:latest

# Install required packages for iptables and ip commands
RUN apk --no-cache add iptables iproute2

WORKDIR /root/

# Copy the binary from builder stage
COPY --from=builder /app/main .

# Copy frontend files
COPY frontend/ ./frontend/

# Create config directory
RUN mkdir -p /etc/web-ui-mgmt

# Expose port
EXPOSE 8080

# Run the application
CMD ["./main"]
