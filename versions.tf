terraform {
  required_version = ">= 1.3"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.101"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.47"
    }
    azurecaf = {
      source  = "claranet/azurecaf"
      version = "~> 1.2, >= 1.2.22"
    }
    time = {
      source  = "hashicorp/time"
      version = "~> 0.12"
    }
  }
}
