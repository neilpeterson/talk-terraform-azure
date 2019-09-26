## Setup

Create storage account.

```
RESOURCE_GROUP_NAME=tstate
STORAGE_ACCOUNT_NAME=tstate071
CONTAINER_NAME=tstate

az group create --name $RESOURCE_GROUP_NAME --location eastus
az storage account create --resource-group $RESOURCE_GROUP_NAME --name $STORAGE_ACCOUNT_NAME --sku Standard_LRS --encryption-services blob
ACCOUNT_KEY=$(az storage account keys list --resource-group $RESOURCE_GROUP_NAME --account-name $STORAGE_ACCOUNT_NAME --query [0].value -o tsv)
az storage container create --name $CONTAINER_NAME --account-name $STORAGE_ACCOUNT_NAME --account-key $ACCOUNT_KEY
echo "storage_account_name: $STORAGE_ACCOUNT_NAME"
echo "container_name: $CONTAINER_NAME"
echo "access_key: $ACCOUNT_KEY"
```

When done, update backend configuration and the storage account keys list command.

## Demo 1: Basic Terraform Configuration

- Show basic Terraform configuration
- Show Terraform docs
- Run configuration
- Show state file

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
    storage_account_name  = "tstate071"
    container_name        = "tstate"
    key                   = "terraform.tfstate"
  }
}
```

Prop up storage account key.

```
az storage account keys list --resource-group tstate --account-name tstate071
export ARM_ACCESS_KEY=
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
