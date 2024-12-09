# Web Application Helm Chart

## Overview
This Helm chart deploys a Python web application with Redis integration, featuring automated backups, connection testing, and configurable features.

## Key Features
- Python web application deployment
- Redis integration with authentication
- Automated Redis backups
- Connection testing
- Configurable environment and features
- Persistent storage support

## Prerequisites
- Kubernetes cluster
- Helm v3
- Storage class available in your cluster
- Redis (automatically deployed if enabled)

## Quick Start

1. Install the chart with default values:
```bash
helm install myapp webapp/
```

2. Install with Redis enabled:
```bash
helm install myapp webapp/ --set redis.enabled=true,redis.auth.password=mypassword
```

## Components

### Main Application
- Python 3.9 web application
- Configurable through environment variables
- Supports feature flags
- Integrates with Redis when enabled

### Redis Integration
1. **Connection Testing**
   - Automatic post-install connection verification
   - Ensures Redis is accessible to the application
   - Configure with `connectionTest.enabled: true`

2. **Automated Backups**
   - Pre-upgrade Redis data backup
   - Backups stored in persistent volume
   - Enable with `backup.enabled: true`

## Configuration

### Required Values
```yaml
# Minimum required configuration
service:
  type: ClusterIP    # Service type (ClusterIP, NodePort, LoadBalancer)
  port: 80           # Service port

global:
  configMapName: "webapp-config"    # ConfigMap for application config
  storageClass: "standard"          # Storage class for PVCs
```

### Redis Configuration
```yaml
redis:
  enabled: true                    # Enable Redis integration
  auth:
    enabled: true                  # Enable Redis authentication
    password: "your-password"      # Redis password

config:
  redis:
    host: "webapp-redis-master"    # Redis host
    port: 6379                     # Redis port
```

### Application Features
```yaml
config:
  env:
    APP_ENV: production           # Environment (development, production, staging)
    DEBUG: "false"               # Enable debug mode
  features:                      # Optional features
    - metrics
    - logging
    - tracing
```

### Persistence
```yaml
persistence:
  enabled: true                  # Enable persistent storage

backupPVC:
  size: 1Gi                     # Backup volume size
  storageClassName: standard    # Storage class for backups
```

## Validation
The chart includes automatic validation for:
- Redis configuration when enabled
- Storage class when persistence is enabled
- Service type validity

## Hooks
1. **Post-Install**
   - Redis connection test (if enabled)
   - Application deployment

2. **Pre-Upgrade**
   - Redis backup (if enabled)

## Version Features
The chart includes version-specific features:
- Version >= 1.0.0 enables new features automatically
- Configurable through Chart version

## Testing
```yaml
tests:
  enabled: true
  persistence:
    enabled: true
```
Enables Helm tests to verify deployment.

## Troubleshooting

### Common Issues
1. Redis Connection Failures
   - Verify Redis password is correct
   - Check if Redis service is running
   - Ensure network policies allow connection

2. Storage Issues
   - Verify storage class exists
   - Check PVC status
   - Ensure sufficient storage capacity

### Debug Tips
1. Check Redis connection test logs:
```bash
kubectl logs job/myapp-redis-connection-test
```

2. Verify Redis backup job:
```bash
kubectl logs job/myapp-redis-backup
```

3. Check application logs:
```bash
kubectl logs deployment/webapp
