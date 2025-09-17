# Key Vault configuration
key_vault_name = "poc-prod-kv-12345"  # Must be globally unique
key_vault_sku  = "standard"

# Key Vault features (prod settings)
enable_disk_encryption      = true
enable_deployment          = true
enable_template_deployment = true
enable_purge_protection    = false  # Prod - stricter cleanup
soft_delete_retention_days = 7      # Minimum for prod

# Network access (prod - more restrictive)
public_network_access_enabled = false
default_network_action        = "Deny"  # Prod - more restrictive
allowed_ip_ranges            = []        # Empty - deny all IPs by default

# Access policies
admin_object_ids = []  # Add your Azure AD object IDs here if needed

# Application secrets (individual variables)
app_insights_connection_string = "mock-app-insights-connection-string"
storage_connection_string      = "mock-storage-connection-string"
api_key_external              = "mock-external-api-key"