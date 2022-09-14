terraform {
  required_version = "~> 1.2.7"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.22"
    }
  }
}

provider "azurerm" {
  features {}
  # skip_provider_registration is set to true since my Azure user has restricted permission
  skip_provider_registration = "true"
}
