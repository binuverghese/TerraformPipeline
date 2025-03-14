variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}

variable "location" {
  description = "The Azure region where resources will be created."
  type        = string
}

variable "name" {
  description = "The name of the virtual network."
  type        = string
}

variable "address_space" {
  description = "The address space for the virtual network."
  type        = list(string)
}

variable "dns_servers" {
  description = "The DNS servers for the virtual network."
  type        = list(string)
  default     = []
}

variable "ddos_protection_plan" {
  description = "DDoS protection plan configuration."
  type = object({
    id     = string
    enable = bool
  })
  default = null
}

variable "enable_vm_protection" {
  description = "Enable VM protection."
  type        = bool
  default     = false
}

variable "encryption" {
  description = "Encryption settings for the virtual network."
  type = object({
    enabled     = bool
    enforcement = string
  })
  default = null
}

variable "flow_timeout_in_minutes" {
  description = "Flow timeout setting in minutes."
  type        = number
  default     = 30
}

variable "subnets" {
  description = "Configuration for the subnets."
  type = map(object({
    name                            = string
    address_prefixes                = list(string)
    default_outbound_access_enabled = bool
    delegation = list(object({
      name               = string
      service_delegation = object({ name = string })
    }))
    nat_gateway = object({ id = string })
    network_security_group = object({ id = string })
    route_table = object({ id = string })
    service_endpoints        = list(string)
    service_endpoint_policies = map(object({ id = string }))
    role_assignments = map(object({
      principal_id               = string
      role_definition_id_or_name = string
    }))
  }))
}

variable "diagnostic_settings" {
  description = "Diagnostic settings for monitoring."
  type = map(object({
    name                           = string
    workspace_resource_id          = string
    log_analytics_destination_type = string
  }))
  default = {}
}

variable "peerings" {
  description = "Configuration for virtual network peerings."
  type = map(object({
    name                                  = string
    remote_virtual_network_resource_id    = string
    allow_forwarded_traffic               = bool
    allow_gateway_transit                 = bool
    allow_virtual_network_access          = bool
    do_not_verify_remote_gateways         = bool
    enable_only_ipv6_peering              = bool
    use_remote_gateways                   = bool
    create_reverse_peering                = bool
    reverse_name                          = string
    reverse_allow_forwarded_traffic       = bool
    reverse_allow_gateway_transit         = bool
    reverse_allow_virtual_network_access  = bool
    reverse_do_not_verify_remote_gateways = bool
    reverse_enable_only_ipv6_peering      = bool
    reverse_use_remote_gateways           = bool
  }))
  default = {}
}
variable "address_space_vnet1" {
  description = "The address space for VNet1"
  type        = list(string)
}


