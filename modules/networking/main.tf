terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

# Virtual Network
resource "azurerm_virtual_network" "main" {
  name                = var.vnet_name
  address_space       = var.vnet_address_space
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.common_tags
}

# App Service Subnet (with delegation)
resource "azurerm_subnet" "app_service" {
  name                 = var.app_service_subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = var.app_service_subnet_prefix
  service_endpoints = ["Microsoft.Sql", "Microsoft.KeyVault", "Microsoft.Storage"]

  # Delegation for App Service VNet Integration
  delegation {
    name = "app-service-delegation"
    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

# Database Subnet (with service endpoints)
resource "azurerm_subnet" "database" {
  name                 = var.database_subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = var.database_subnet_prefix

  # Service endpoints for secure database access
  service_endpoints = ["Microsoft.Sql", "Microsoft.KeyVault", "Microsoft.Storage"]
}

# Network Security Group for App Service subnet
resource "azurerm_network_security_group" "app_service" {
  count = var.enable_app_service_nsg ? 1 : 0

  name                = "${var.vnet_name}-app-service-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.common_tags

  # Allow HTTPS inbound
  security_rule {
    name                       = "Allow-HTTPS-Inbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # Allow HTTP inbound (for dev/staging)
  security_rule {
    name                       = "Allow-HTTP-Inbound"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # Allow outbound internet (for dependencies, APIs, etc.)
  dynamic "security_rule" {
    for_each = var.allow_internet_outbound ? [1] : []
    content {
      name                       = "Allow-Internet-Outbound"
      priority                   = 100
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "Internet"
    }
  }

  # Deny all other inbound traffic
  security_rule {
    name                       = "Deny-All-Inbound"
    priority                   = 4096
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Network Security Group for Database subnet
resource "azurerm_network_security_group" "database" {
  count = var.enable_database_nsg ? 1 : 0

  name                = "${var.vnet_name}-database-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.common_tags

  # Allow SQL from App Service subnet only
  security_rule {
    name                       = "Allow-SQL-From-AppService"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "1433"
    source_address_prefixes    = var.app_service_subnet_prefix
    destination_address_prefix = "*"
  }

  # Allow HTTPS for service endpoints
  security_rule {
    name                       = "Allow-HTTPS-ServiceEndpoints"
    priority                   = 110
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # Deny all other traffic
  security_rule {
    name                       = "Deny-All-Inbound"
    priority                   = 4096
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Associate NSGs with subnets
resource "azurerm_subnet_network_security_group_association" "app_service" {
  count = var.enable_app_service_nsg ? 1 : 0

  subnet_id                 = azurerm_subnet.app_service.id
  network_security_group_id = azurerm_network_security_group.app_service[0].id
}

resource "azurerm_subnet_network_security_group_association" "database" {
  count = var.enable_database_nsg ? 1 : 0

  subnet_id                 = azurerm_subnet.database.id
  network_security_group_id = azurerm_network_security_group.database[0].id
}

# Optional: VNet Peering (for connecting to hub networks)
resource "azurerm_virtual_network_peering" "hub_peering" {
  count = var.hub_vnet_id != null ? 1 : 0

  name                      = "${var.vnet_name}-to-hub"
  resource_group_name       = var.resource_group_name
  virtual_network_name      = azurerm_virtual_network.main.name
  remote_virtual_network_id = var.hub_vnet_id
  allow_virtual_network_access = true
  allow_forwarded_traffic   = true
  allow_gateway_transit     = false
  use_remote_gateways       = var.use_hub_gateway
}