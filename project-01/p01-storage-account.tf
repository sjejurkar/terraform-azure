resource "azurerm_storage_account" "sa" {
  name                      = "${var.environment}${var.storage_account_name}"
  resource_group_name       = azurerm_resource_group.rg.name
  location                  = azurerm_resource_group.rg.location
  account_tier              = var.storage_account_sku.tier
  account_replication_type  = var.storage_account_sku.type
  account_kind              = "StorageV2"
  enable_https_traffic_only = true
  tags = {
    environment = var.environment
    source      = var.creation_source
  }
}

# Create the queue
resource "azurerm_storage_queue" "queue" {
  name                 = var.storage_queue_name
  storage_account_name = azurerm_storage_account.sa.name
}