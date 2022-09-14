resource "azurerm_api_management" "apim" {
  name                = "${var.environment}-${var.apim_name}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  publisher_name      = var.apimPublisherName
  publisher_email     = var.apimPublisherEmail
  tags = {
    environment = var.environment
    source      = var.creation_source
  }

  sku_name = "${var.apimSku}_${var.apimSkuCapacity}"

  identity {
    type = "SystemAssigned"
  }

  # policy {
  #   xml_link = var.tenantPolicyUrl
  # }
}

# Assign "Storage Queue Data Message Sender" permissions to API management resource
resource "azurerm_role_assignment" "assign-send-permissions" {
  scope                = azurerm_storage_account.sa.id
  role_definition_name = "Storage Queue Data Message Sender"
  principal_id         = azurerm_api_management.apim.identity[0].principal_id
}

# Create API in API management
resource "azurerm_api_management_api" "api" {
  name                = "queue-api"
  resource_group_name = azurerm_resource_group.rg.name
  api_management_name = azurerm_api_management.apim.name
  revision            = "1"
  display_name        = "Message API"
  path                = "api"
  protocols           = ["https"]
  service_url         = "${azurerm_storage_account.sa.primary_queue_endpoint}${azurerm_storage_queue.queue.name}"
}

# Add operation to API
resource "azurerm_api_management_api_operation" "operation" {
  operation_id        = "post-message"
  api_name            = azurerm_api_management_api.api.name
  api_management_name = azurerm_api_management_api.api.api_management_name
  resource_group_name = azurerm_api_management.apim.resource_group_name
  display_name        = "Post message to the storage queue"
  method              = "POST"
  url_template        = "/"
  description         = "Post message to the storage queue"

  response {
    status_code = 202
  }
}

# Configure policy on operation
resource "azurerm_api_management_api_operation_policy" "policy" {
  api_name            = azurerm_api_management_api_operation.operation.api_name
  api_management_name = azurerm_api_management_api_operation.operation.api_management_name
  resource_group_name = azurerm_api_management_api_operation.operation.resource_group_name
  operation_id        = azurerm_api_management_api_operation.operation.operation_id

  xml_content = <<XML
  <policies>
      <inbound>
          <base />
          <set-header name="x-ms-version" exists-action="override">
              <value>2021-08-06</value>
          </set-header>
          <authentication-managed-identity resource="https://storage.azure.com/" />
          <set-header name="content-type" exists-action="override">
              <value>application/xml</value>
          </set-header>
          <set-body>@{
                  return "<QueueMessage><MessageText>" + context.Request.Body.As<string>() + "</MessageText></QueueMessage>";
              }</set-body>
          <rewrite-uri template="/messages" copy-unmatched-params="true" />
      </inbound>
      <backend>
          <forward-request />
      </backend>
      <outbound>
          <return-response>
              <set-status code="202" />
          </return-response>
          <base />
      </outbound>
      <on-error>
          <base />
      </on-error>
  </policies>
XML
}