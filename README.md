## Demo 1: Basic Terraform Configuration

```
terraform init
terraform plan --out plan.out
terraform apply plan.out
```

## Demo 2: Terraform State

Add backend file to directory.

```
terraform {
  backend "azurerm" {
    storage_account_name  = "nepetersterraformstate"
    container_name        = "tstate"
    key                   = "terraform.tfstate"
  }
}
```

Prop up storage account key.

```
az storage account keys list --resource-group terraform-state --account-name nepetersterraformstate
export ARM_ACCESS_KEY=<access_key>
```

Re-initalize to copy state to storage account

```
terraform init
```

At this point, remove the local state file.

```
rm terraform.tfstate
rm terraform.tfstate.backup
```

## Demo 3: Workspaces

```
terraform workspace list
terraform workspace new test-environment
```

Update config:

```
resource "azurerm_resource_group" "hello-world" {
  name     = "${var.resource_group}-${terraform.workspace}"
  location = var.location
}

resource "random_integer" "ri" {
  min = 10000
  max = 99999
}

resource "azurerm_container_group" "hello-world" {
  name                = lower(var.container-name)
  location            = azurerm_resource_group.hello-world.location
  resource_group_name = azurerm_resource_group.hello-world.name
  ip_address_type     = "public"
  dns_name_label      = "${var.dns-prefix}-${random_integer.ri.result}"
  os_type             = "linux"

  container {
    name   = "hello-world"
    image  = var.container-image
    cpu    = "0.5"
    memory = "1.5"
    ports {
      port     = 80
      protocol = "TCP"
    }
  }
}
```

Run the new config:

```
terraform plan --out plan.out
terraform apply plan.out
```

## Demo 4: Testing Terraform

```
go test
```

## Demo 5: CI/CD
