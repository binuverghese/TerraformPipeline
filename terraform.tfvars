address_space = ["10.0.0.0/16"]
address_space_vnet1 = ["10.0.1.0/24"]

subnets = {
  subnet1 = {
    name                            = "subnet1"
    address_prefixes                = ["10.0.1.0/24"]
    default_outbound_access_enabled = false
    network_security_group = {
      id = "/subscriptions/xxx/resourceGroups/xxx/providers/Microsoft.Network/networkSecurityGroups/nsg1"
    }
    route_table = {
      id = "/subscriptions/xxx/resourceGroups/xxx/providers/Microsoft.Network/routeTables/rt1"
    }
    service_endpoints = ["Microsoft.Storage"]

    delegation                  = []  # No delegation
    nat_gateway                 = null  # No NAT Gateway
    role_assignments            = {}  # No role assignments
    service_endpoint_policies   = {}  # No service endpoint policies
  }

  subnet2 = {
    name                            = "subnet2"
    address_prefixes                = ["10.0.2.0/24"]
    default_outbound_access_enabled = false 
    network_security_group = {               
      id = "/subscriptions/xxx/resourceGroups/xxx/providers/Microsoft.Network/networkSecurityGroups/nsg2"
    }
    route_table = {                          
      id = "/subscriptions/xxx/resourceGroups/xxx/providers/Microsoft.Network/routeTables/rt2"
    }
    service_endpoints = ["Microsoft.KeyVault"]

    delegation                  = []  # No delegation
    nat_gateway                 = null  # No NAT Gateway
    role_assignments            = {}  # No role assignments
    service_endpoint_policies   = {}  # No service endpoint policies
  }
}
