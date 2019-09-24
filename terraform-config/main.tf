provider "azurerm" {
  version = "=1.29.0"
}

resource "azurerm_resource_group" "hello-world" {
  name     = "${var.resource_group}"
  location = "${var.location}"
}

resource "random_integer" "ri" {
  min = 10000
  max = 99999
}

resource "azurerm_container_group" "hello-world" {
  name                = "${var.container-name}"
  location            = "${azurerm_resource_group.hello-world.location}"
  resource_group_name = "${azurerm_resource_group.hello-world.name}"
  ip_address_type     = "public"
  dns_name_label      = "${var.dns-prefix}-${random_integer.ri.result}"
  os_type             = "linux"

  container {
    name   = "hello-world"
    image  = "${var.container-image}"
    cpu    = "0.5"
    memory = "1.5"

    ports {
      port      = 80
      protocol  = "TCP"
    }

  }
}