# Azure Infrastructure as Code - Terragrunt Project

## 📋 Overview

This project contains Infrastructure as Code (IaC) for a business application on Azure, using Terraform with Terragrunt for multi-environment management. The infrastructure consists of modular components providing a secure and scalable environment for a Python FastAPI application with automated CI/CD pipelines.

## 🏗️ Architecture

### Infrastructure Components:
- **Resource Group** - Azure resource group
- **Networking** - Virtual Network with subnets and NSGs
- **Security** - Key Vault for secrets management
- **Database** - Azure SQL Database with SQL Server
- **App Service** - Linux App Service for Python application

### Application Stack:
- **Python 3.11** - FastAPI web application
- **Docker** - Containerized deployment
- **Azure Container Registry** - Container image storage
- **GitHub Actions** - CI/CD automation

### Environments:
- **dev** - Development environment (basic configuration)
- **prod** - Production environment (advanced configuration with blue-green deployment)

## 📁 Project Structure

```
.
├── README.md                          # This documentation
├── terragrunt.hcl                     # Main Terragrunt configuration
├── .gitignore                         # Git ignored files
├── .github/                           # GitHub Actions workflows
│   └── workflows/
│       ├── deploy-infrastructure.yml  # Infrastructure deployment
│       ├── deploy-application.yml     # Application deployment
│       └── database-migration.yml     # Database migrations
├── app/                               # Python application
│   ├── Dockerfile                     # Container configuration
│   ├── requirements.txt               # Python dependencies
│   ├── main.py                        # FastAPI application
│   ├── database.py                    # Database configuration
│   ├── alembic.ini                    # Database migration config
│   ├── alembic/                       # Database migrations
│   │   └── versions/
│   ├── routers/                       # API routes
│   │   ├── __init__.py
│   │   ├── health.py                  # Health check endpoints
│   │   └── api.py                     # Business logic APIs
│   └── tests/                         # Test files
│       ├── __init__.py
│       ├── test_main.py
│       └── test_health.py
├── modules/                           # Terraform modules
│   ├── resource-group/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── networking/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── security/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── database/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── app-service/
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
└── environments/                      # Environment configurations
    ├── dev/
    │   ├── resource-group/
    │   │   ├── terragrunt.hcl
    │   │   └── terraform.tfvars
    │   ├── networking/
    │   │   ├── terragrunt.hcl
    │   │   └── terraform.tfvars
    │   ├── security/
    │   │   ├── terragrunt.hcl
    │   │   └── terraform.tfvars
    │   ├── database/
    │   │   ├── terragrunt.hcl
    │   │   └── terraform.tfvars
    │   └── app-service/
    │       ├── terragrunt.hcl
    │       └── terraform.tfvars
    └── prod/
        └── [same structure as dev]
```

## 🔧 Prerequisites

### Tools Required:
- **Terraform** >= 1.5
- **Terragrunt** >= 0.50
- **Azure CLI** >= 2.0
- **Docker** >= 20.0
- **Python** >= 3.11
- **Git**

### Environment Variables:
```bash
export ARM_SUBSCRIPTION_ID="your-subscription-id"
export ARM_TENANT_ID="your-tenant-id"
export ARM_CLIENT_ID="your-client-id"
export ARM_CLIENT_SECRET="your-client-secret"

# For Terraform State
export TFSTATE_RESOURCE_GROUP="your-tfstate-rg"
export TFSTATE_STORAGE_ACCOUNT="your-tfstate-storage"
export TFSTATE_CONTAINER="your-tfstate-container"

# For deployment tracking
export BUILD_REQUESTEDFOR="your-name"
```

## 🚀 Deployment

### 1. Infrastructure Deployment (Manual)

#### Initial Setup
```bash
# Clone the repository
git clone <repository-url>
cd example-business-app

# Login to Azure
az login
az account set --subscription "your-subscription-id"
```

#### Deploy Development Environment
```bash
# Deploy in order (dependencies matter)
cd environments/dev/resource-group
terragrunt apply

cd ../networking
terragrunt apply

cd ../security
terragrunt apply

cd ../database
terragrunt apply

cd ../app-service
terragrunt apply
```

#### Deploy All Components at Once
```bash
# From environment root
cd environments/dev
terragrunt run-all apply

# Or for production
cd environments/prod
terragrunt run-all apply
```

### 2. Application Deployment (Automated via GitHub Actions)

The application is automatically deployed using GitHub Actions workflows:

#### Automatic Triggers:
- **Development**: Push to `develop` branch
- **Production**: Push to `main` branch (after dev deployment)
- **Manual**: Workflow dispatch with environment selection

#### Deployment Process:
1. **Build** - Create Docker image and push to Azure Container Registry
2. **Deploy Dev** - Deploy to development environment
3. **Deploy Prod** - Deploy to production with blue-green deployment
4. **Health Checks** - Verify application health after deployment

## 🔄 CI/CD Workflows

### Infrastructure Deployment (`.github/workflows/deploy-infrastructure.yml`)
- **Triggers**: Push to main, PR, manual dispatch
- **Features**: 
  - Terraform validation
  - Plan for dev environment on PR
  - Deploy dev on main branch push
  - Deploy prod with approval gates

### Application Deployment (`.github/workflows/deploy-application.yml`)
- **Triggers**: Push to main/develop, PR, manual dispatch
- **Features**:
  - Docker build and push to ACR
  - Blue-green deployment for production
  - Automatic rollback on failure

## 📦 Modules Description

### Resource Group Module
- Creates Azure Resource Group
- Configurable resource locks
- Common tagging strategy

**Key Variables:**
- `resource_group_name` - Name of the resource group
- `location` - Azure region
- `enable_resource_lock` - Enable management lock

### Networking Module
- Virtual Network with configurable address space
- App Service and Database subnets
- Network Security Groups
- Optional DDoS protection and flow logs

**Key Variables:**
- `vnet_name` - Virtual network name
- `vnet_address_space` - CIDR blocks for VNet
- `app_service_subnet_prefix` - App Service subnet CIDR
- `database_subnet_prefix` - Database subnet CIDR

### Security Module
- Azure Key Vault for secrets management
- Configurable access policies
- Network access controls
- Automatic secret generation for SQL passwords

**Key Variables:**
- `key_vault_name` - Key Vault name (globally unique)
- `key_vault_sku` - Standard or Premium
- `public_network_access_enabled` - Allow public access

### Database Module
- Azure SQL Server with managed identity
- SQL Database with configurable SKU
- Backup and retention policies
- Threat detection (prod only)
- Network access rules

**Key Variables:**
- `sql_server_name` - SQL Server name (globally unique)
- `database_name` - Database name
- `database_sku_name` - Database SKU (Basic, S1, S2, etc.)
- `backup_retention_days` - Backup retention period

### App Service Module
- Linux App Service Plan
- Python web application
- VNet integration for secure communication
- Application settings with Key Vault references
- Health check configuration

**Key Variables:**
- `app_service_plan_name` - App Service Plan name
- `web_app_name` - Web App name (globally unique)
- `sku_name` - App Service Plan SKU
- `python_version` - Python runtime version

## 🐍 Python Application

### Local Development
```bash
cd app

# Install dependencies
pip install -r requirements.txt

# Run application
python main.py

# Run tests
pytest tests/

# Run with Docker
docker build -t python-app .
docker run -p 8000:8000 python-app
```

## 🔄 Dependencies

The modules have the following dependency chain:
1. **Resource Group** (no dependencies)
2. **Networking** (depends on Resource Group)
3. **Security** (depends on Resource Group)
4. **Database** (depends on Resource Group, Security)
5. **App Service** (depends on all previous modules)

## 🌍 Environment Differences

### Development (dev)
- Basic SKUs for cost optimization
- Public network access enabled
- Minimal backup retention (7 days)
- Threat detection disabled
- Single availability zone
- Direct deployment from develop branch

### Production (prod)
- Higher SKUs for performance
- Restricted network access
- Extended backup retention (35 days)
- Threat detection enabled
- Zone redundancy enabled
- DDoS protection enabled
- Blue-green deployment with staging slots
- Manual approval gates

## 🔐 GitHub Secrets Configuration

Configure these secrets in your GitHub repository:

### Azure Authentication
```
AZURE_CREDENTIALS          # Service principal JSON
AZURE_CLIENT_ID            # Service principal client ID
AZURE_CLIENT_SECRET        # Service principal secret
AZURE_SUBSCRIPTION_ID      # Azure subscription ID
AZURE_TENANT_ID           # Azure tenant ID
```

### Container Registry
```
ACR_LOGIN_SERVER          # Azure Container Registry URL
ACR_USERNAME              # ACR username
ACR_PASSWORD              # ACR password
```

### Terraform State
```
TFSTATE_RESOURCE_GROUP    # Resource group for state
TFSTATE_STORAGE_ACCOUNT   # Storage account for state
TFSTATE_CONTAINER         # Container for state files
```

