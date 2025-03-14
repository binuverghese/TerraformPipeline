variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The Azure region where resources will be created"
  type        = string
}

variable "address_space_vnet1" {
  description = "Address space for vnet1"
  type        = list(string)
  default     = ["192.168.0.0/16"]
}

variable "address_space_vnet2" {
  description = "Address space for vnet2"
  type        = list(string)
  default     = ["10.0.0.0/27"]
}

variable "dns_servers" {
  description = "List of DNS servers"
  type        = list(string)
  default     = ["8.8.8.8"]
}

variable "enable_ddos_protection" {
  description = "Enable DDoS protection"
  type        = bool
  default     = false
}

variable "enable_vm_protection" {
  description = "Enable VM protection"
  type        = bool
  default     = true
}

variable "encryption_enabled" {
  description = "Enable encryption for virtual network"
  type        = bool
  default     = true
}

variable "encryption_enforcement" {
  description = "Encryption enforcement mode"
  type        = string
  default     = "AllowUnencrypted"
}

variable "flow_timeout" {
  description = "Flow timeout in minutes"
  type        = number
  default     = 30
}
