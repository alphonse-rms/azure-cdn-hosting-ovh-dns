terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 2.92.0"
    }
    ovh = {
      source  = "ovh/ovh"
      version = ">= 0.13.0"
    }
  }
}
