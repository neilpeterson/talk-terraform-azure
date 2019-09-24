terraform {
  backend "azurerm" {
    storage_account_name  = "nepetersterraformstate"
    container_name        = "tstate"
    key                   = "terraform.tfstate"
  }
}