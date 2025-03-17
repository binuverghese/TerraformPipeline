terraform {
  required_version = ">= 1.9, < 2.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.74"
    }
    http = {
      source  = "hashicorp/http"
      version = "~> 3.4"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

module "regions" {
  source  = "Azure/regions/azurerm"
  version = "~> 0.3"
}

resource "random_integer" "region_index" {
  max = length(module.regions.regions) - 1
  min = 0
}

module "naming" {
  source  = "Azure/naming/azurerm"
  version = "~> 0.3"
  # location            = var.location
  # resource_group_name = var.resource_group_name
  # address_space       = var.address_space_vnet1
  # subnets             = var.subnets 
 }

resource "azurerm_resource_group" "this" {
  location = var.location
  name     = var.resource_group_name
}

resource "azurerm_route_table" "this" {
  location            = var.location
  name                = module.naming.route_table.name_unique
  resource_group_name = var.resource_group_name
}

resource "azurerm_network_ddos_protection_plan" "this" {
  location            = var.location
  name                = module.naming.network_ddos_protection_plan.name_unique
  resource_group_name = var.resource_group_name
}

resource "azurerm_nat_gateway" "this" {
  location            = var.location
  name                = module.naming.nat_gateway.name_unique
  resource_group_name = var.resource_group_name
}

data "http" "public_ip" {
  method = "GET"
  url    = "http://api.ipify.org?format=json"
}

resource "azurerm_network_security_group" "https" {
  location            = var.location
  name                = module.naming.network_security_group.name_unique
  resource_group_name = var.resource_group_name

  security_rule {
    access                     = "Allow"
    destination_address_prefix = "*"
    destination_port_range     = "443"
    direction                  = "Inbound"
    name                       = "AllowInboundHTTPS"
    priority                   = 100
    protocol                   = "Tcp"
    source_address_prefix      = jsondecode(data.http.public_ip.response_body).ip
    source_port_range          = "*"
  }
}

resource "azurerm_user_assigned_identity" "this" {
  location            = var.location
  name                = module.naming.user_assigned_identity.name_unique
  resource_group_name = var.resource_group_name
}

resource "azurerm_storage_account" "this" {
  account_replication_type = "ZRS"
  account_tier             = "Standard"
  location                 = var.location
  name                     = module.naming.storage_account.name_unique
  resource_group_name      = var.resource_group_name
}

resource "azurerm_log_analytics_workspace" "this" {
  location            = var.location
  name                = module.naming.log_analytics_workspace.name_unique
  resource_group_name = var.resource_group_name
}

module "vnet1" {
  source              = "../../"
  #resource_group_name = var.resource_group_name
  #location            = var.location
  #name                = module.naming.virtual_network.name_unique
  #address_space       = var.address_space_vnet1

  #dns_servers = {
   # dns_servers = var.dns_servers
  #}

 # ddos_protection_plan = {
   # id     = azurerm_network_ddos_protection_plan.this.id
   # enable = var.enable_ddos_protection
  #}

  #enable_vm_protection = var.enable_vm_protection

  #encryption = {
   # enabled     = var.encryption_enabled
   # enforcement = var.encryption_enforcement
 # }

  #flow_timeout_in_minutes = var.flow_timeout
}

module "vnet2" {
  source              = "../../"
  # resource_group_name = var.resource_group_name
  # location            = var.location
  # name                = "${module.naming.virtual_network.name_unique}2"
  # address_space       = var.address_space_vnet2

  # encryption = {
  #   enabled     = var.encryption_enabled
  #   enforcement = var.encryption_enforcement
  # }

  # peerings = {
  #   peertovnet1 = {
  #     name                                  = "${module.naming.virtual_network_peering.name_unique}-vnet2-to-vnet1"
  #     remote_virtual_network_resource_id    = module.vnet1.resource_id
  #     allow_forwarded_traffic               = true
  #     allow_gateway_transit                 = true
  #     allow_virtual_network_access          = true
  #     do_not_verify_remote_gateways         = false
  #     enable_only_ipv6_peering              = false
  #     use_remote_gateways                   = false
  #     create_reverse_peering                = true
  #     reverse_name                          = "${module.naming.virtual_network_peering.name_unique}-vnet1-to-vnet2"
  #     reverse_allow_forwarded_traffic       = false
  #     reverse_allow_gateway_transit         = false
  #     reverse_allow_virtual_network_access  = true
  #     reverse_do_not_verify_remote_gateways = false
  #     reverse_enable_only_ipv6_peering      = false
  #     reverse_use_remote_gateways           = false
  #   }
  # }
}
