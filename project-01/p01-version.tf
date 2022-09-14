terraform {
  required_version = "~> 1.2.7"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.22"
    }

    azapi = {
      source = "Azure/azapi"
    }
  }

}

provider "azurerm" {
  features {}
  # skip_provider_registration is set to true since my Azure user has restricted permission
  skip_provider_registration = "true"
}

provider "azapi" {
}

# Reference to the environment
data "azurerm_client_config" "current" {}