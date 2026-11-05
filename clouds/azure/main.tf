# An Azure root (`cloud: azure` in .cbx-guard.yml, CB-1171 / REV-130). The e2e org connects no Azure
# subscription, so the review plans it offline (the azurerm recipe in
# apps/api/src/review/offline-env.ts) and resolves it from the plan only. Its app VM's NSG already
# admits SSH and RDP from 0.0.0.0/0 on the default branch: every review of this root keeps that as a
# pre-existing finding, which opens the note that says the verdict came from the plan only.
# Its resources are named `app`, not `bastion`: a bastion is an expected opening, which the review
# grades clean, and a clean pre-existing finding opens no note.
#
# The azurerm pin is the version the worker image mirrors (infra/docker/terraform/providers.tf), so
# init installs it from disk. realworld-scenarios.test.ts fails when the two drift.
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.81.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

variable "subscription_id" {
  type    = string
  default = "00000000-0000-0000-0000-000000000000"
}

variable "location" {
  type    = string
  default = "westeurope"
}

variable "admin_ssh_public_key" {
  type        = string
  description = "Dummy public key; no private key exists for it."
  default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDzeG//pj5/TPFJlgIBRxxCUNnceUXsuh2S1B/dQwgRI5ye3Z6zuHypN/C8Sv0dFogt+2HP1g8+9qj2zFE9i274ZU8DYohC0+YUt7T6e65dBxda+rkL54rPp9OUEZtBDVC2/Bo7jz1nioMuRpcGIRzJGh6bo1/ESI24GJoygty21j7UULAkUeHFssdtJC8L+3VjEgoR39SEusCayc8JTqAQOz2BTbqVscQZh05XayX0ZSyGoDEeoipu6m8qGx9l0jOIVA4/Cew3B2CZiotiUwewfitjmzfy8Y/jaaoGOowb9FHpZimtVcSPVZDGWNAr003+wfB5JsdioQO5j4Thk3qJ cbx-offline-plan-dummy"
}

locals {
  tags = {
    Environment = "prod"
    Service     = "orders"
  }
}

resource "azurerm_resource_group" "app" {
  name     = "rg-orders-prod"
  location = var.location
  tags     = local.tags
}

resource "azurerm_virtual_network" "app" {
  name                = "vnet-orders-prod"
  location            = azurerm_resource_group.app.location
  resource_group_name = azurerm_resource_group.app.name
  address_space       = ["10.0.0.0/16"]
  tags                = local.tags
}

resource "azurerm_subnet" "app" {
  name                 = "snet-app"
  resource_group_name  = azurerm_resource_group.app.name
  virtual_network_name = azurerm_virtual_network.app.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_security_group" "app" {
  name                = "nsg-app"
  location            = azurerm_resource_group.app.location
  resource_group_name = azurerm_resource_group.app.name
  tags                = local.tags

  security_rule {
    name                       = "allow-admin"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["22", "3389"]
    source_address_prefix      = "0.0.0.0/0"
    destination_address_prefix = "*"
  }
}

resource "azurerm_public_ip" "app" {
  name                = "pip-app"
  location            = azurerm_resource_group.app.location
  resource_group_name = azurerm_resource_group.app.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = local.tags
}

resource "azurerm_network_interface" "app" {
  name                = "nic-app"
  location            = azurerm_resource_group.app.location
  resource_group_name = azurerm_resource_group.app.name
  tags                = local.tags

  ip_configuration {
    name                          = "primary"
    subnet_id                     = azurerm_subnet.app.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.app.id
  }
}

resource "azurerm_network_interface_security_group_association" "app" {
  network_interface_id      = azurerm_network_interface.app.id
  network_security_group_id = azurerm_network_security_group.app.id
}

resource "azurerm_linux_virtual_machine" "app" {
  name                  = "vm-app"
  location              = azurerm_resource_group.app.location
  resource_group_name   = azurerm_resource_group.app.name
  size                  = "Standard_B2s"
  admin_username        = "azureuser"
  network_interface_ids = [azurerm_network_interface.app.id]
  tags                  = local.tags

  admin_ssh_key {
    username   = "azureuser"
    public_key = var.admin_ssh_public_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }
}
