terraform {
  required_version = ">= 1.9"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4"
    }
  }
}

provider "azurerm" {
  subscription_id = "00000000-0000-0000-0000-000000000000"
  features {}
}

module "azure_core" {
  source = "../.."

  resource_group_name = "example-rg"

  key_vault = {
    name = "example-kv"
  }

  container_registry = {
    name = "example-acr"
  }


  location = "West Europe"
  tags     = { Environment = "Production" }
}