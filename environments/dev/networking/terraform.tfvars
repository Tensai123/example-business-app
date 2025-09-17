# VNet configuration
vnet_name          = "poc-dev-vnet"
vnet_address_space = ["10.0.0.0/16"]

# Subnets configuration
app_service_subnet_name   = "snet-app-service"
app_service_subnet_prefix = ["10.0.1.0/24"]
database_subnet_name      = "snet-database"
database_subnet_prefix    = ["10.0.2.0/24"]

# Network Security Groups
enable_app_service_nsg  = true
enable_database_nsg     = true
allow_internet_outbound = true

# Dev-specific settings
enable_ddos_protection  = false
enable_flow_logs       = false

# Hub networking (not used in dev)
hub_vnet_id      = null
use_hub_gateway  = false

# Custom DNS (use Azure default)
dns_servers = []