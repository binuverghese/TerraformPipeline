terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.0.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Resource Group
module "resource_group" {
  source  = "Azure/avm-resource-group/azurerm"
  version = "1.0.0"

  resource_group_name = var.resource_group_name
  location           = var.location
}

# Virtual Network
module "network" {
  source  = "Azure/avm-networking/azurerm"
  version = "1.0.0"

  vnet_name           = var.vnet_name
  resource_group_name = module.resource_group.name
  location           = module.resource_group.location
  address_space      = var.address_space
  subnets           = var.subnets
}

# Decentralized Azure Firewall
module "firewall" {
  source  = "Azure/avm-firewall/azurerm"
  version = "1.0.0"

  firewall_name       = var.firewall_name
  resource_group_name = module.resource_group.name
  location           = module.resource_group.location
  vnet_name          = module.network.vnet_name
  subnet_name        = module.network.subnets["subnet-fw"].name

  public_ip = {
    name              = "pip-firewall"
    allocation_method = "Static"
  }
}

# Bastion for Remote Management
module "bastion" {
  source  = "Azure/avm-bastion/azurerm"
  version = "1.0.0"

  bastion_name       = var.bastion_name
  resource_group_name = module.resource_group.name
  location           = module.resource_group.location
  vnet_name         = module.network.vnet_name
  subnet_name       = module.network.subnets["subnet-app"].name

  public_ip = {
    name              = "pip-bastion"
    allocation_method = "Static"
  }
}

# Application Gateway
module "application_gateway" {
  source  = "Azure/avm-application-gateway/azurerm"
  version = "1.0.0"

  application_gateway_name = var.application_gateway_name
  resource_group_name      = module.resource_group.name
  location                = module.resource_group.location
  vnet_name               = module.network.vnet_name
  subnet_name             = module.network.subnets["subnet-app"].name

  sku = {
    name  = "WAF_v2"
    tier  = "WAF_v2"
    capacity = 2
  }
}

# Private DNS (Decentralized)
module "private_dns" {
  source  = "Azure/avm-private-dns/azurerm"
  version = "1.0.0"

  dns_zone_name      = var.dns_zone_name
  resource_group_name = module.resource_group.name
  vnet_name         = module.network.vnet_name
}

# NSG with Security Baseline
module "network_security_group" {
  source  = "Azure/avm-nsg/azurerm"
  version = "1.0.0"

  nsg_name           = var.nsg_name
  resource_group_name = module.resource_group.name
  location           = module.resource_group.location
  security_rules = [
    {
      name                       = "Allow-HTTPS"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  ]
}

# Spoke-to-Spoke Peering (With Approvals)
module "vnet_peering" {
  source  = "Azure/avm-vnet-peering/azurerm"
  version = "1.0.0"

  local_vnet_name  = module.network.vnet_name
  remote_vnet_id   = var.remote_vnet_id
  allow_forwarded_traffic = true
  allow_virtual_network_access = true
}

# Security Center
module "security_center" {
  source  = "Azure/avm-security-center/azurerm"
  version = "1.0.0"

  security_pricing = {
    tier = "Standard"
  }
}

# Monitoring for Security
module "monitoring" {
  source  = "Azure/avm-monitor/azurerm"
  version = "1.0.0"

  resource_id               = module.firewall.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  logs = [
    {
      category = "FirewallRule"
      enabled  = true
    }
  ]
}
