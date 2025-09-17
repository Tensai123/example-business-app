# App Service Plan
app_service_plan_name = "poc-dev-asp"
os_type              = "Linux"
sku_name             = "B1"

# Web App  
web_app_name = "poc-dev-python-app-12345"  # Must be globally unique

# Security
https_only                    = true
public_network_access_enabled = true

# Site Config
minimum_tls_version = "1.2"
ftps_state         = "Disabled"
python_version     = "3.11"

# Health Check
health_check_path                 = "/health"
health_check_eviction_time_in_min = 2

# VNet Integration
enable_vnet_integration = true