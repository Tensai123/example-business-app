# Key Vault configuration
key_vault_name = "poc-dev-kv-123456"  # Must be globally unique
key_vault_sku  = "standard"

# Key Vault features (dev settings)
enable_disk_encryption      = false
enable_deployment          = true
enable_template_deployment = true
enable_purge_protection    = false  # Dev - easier cleanup
soft_delete_retention_days = 7      # Minimum for dev

# Network access (dev - more permissive)
public_network_access_enabled = true
default_network_action        = "Allow"  # Dev - more open for testing
allowed_ip_ranges            = []        # Empty - allow all IPs in dev

# Access policies
admin_object_ids = []  # Add your Azure AD object IDs here if needed

# Application secrets (individual variables)
app_insights_connection_string = "mock-app-insights-connection-string"
storage_connection_string      = "mock-storage-connection-string"
api_key_external              = "mock-external-api-key"