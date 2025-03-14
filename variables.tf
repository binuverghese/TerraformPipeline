variable "location" {
  description = "Azure region for deployment"
  type        = string
  default     = "East US"
}

variable "resource_group_name" {
  description = "Name of the Azure Resource Group"
  type        = string
  default     = "rg-isolated-online"
}

variable "vnet_name" {
  description = "Virtual Network Name"
  type        = string
  default     = "vnet-isolated"
}

variable "address_space" {
  description = "Address space for the VNet"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "subnets" {
  description = "Subnets configuration"
  type = map(object({
    address_prefixes = list(string)
  }))
  default = {
    subnet-app  = { address_prefixes = ["10.0.1.0/24"] }
    subnet-fw   = { address_prefixes = ["10.0.2.0/24"] }
  }
}

variable "firewall_name" {
  description = "Azure Firewall Name"
  type        = string
  default     = "fw-isolated"
}

variable "bastion_name" {
  description = "Azure Bastion Name"
  type        = string
  default     = "bastion-isolated"
}

variable "application_gateway_name" {
  description = "Application Gateway Name"
  type        = string
  default     = "agw-isolated"
}

variable "nsg_name" {
  description = "Network Security Group Name"
  type        = string
  default     = "nsg-isolated"
}

variable "dns_zone_name" {
  description = "Private DNS Zone Name"
  type        = string
  default     = "isolated.private"
}

variable "log_analytics_workspace_id" {
  description = "Log Analytics Workspace ID for Monitoring"
  type        = string
  default     = ""
}

variable "remote_vnet_id" {
  description = "Remote VNet ID for Peering"
  type        = string
  default     = ""
}
