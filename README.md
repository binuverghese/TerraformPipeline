Terraform Configuration for Azure Virtual Network with NSG & Route Table Association
This Terraform project provisions an Azure Virtual Network (VNet), a subnet, and associates it with an existing Network Security Group (NSG) and a User-Defined Route (UDR) table.

Features
Creates an Azure Resource Group
Deploys a Virtual Network (VNet)
Provisions a Subnet
Associates the subnet with:

Existing Network Security Group (NSG) (nsg-weballow-001)
Existing Route Table (UDR) (rt-navigator)
Uses parameterized variables for flexibility.

📂 ConnectedArchetype
│── main.tf                # Terraform configuration
│── variables.tf           # Input variables
│── terraform.tfvars       # Variable values
│── README.md              # Documentation (this file)
│── .gitignore             # Ignore sensitive Terraform files
│── providers.tf           # Terraform providers (if separate)
│── outputs.tf             # Outputs (if needed)

Prerequisites
Terraform v1.9+
Azure CLI (Authenticated with az login)
Existing Azure Network Security Group (NSG)
Existing Route Table (UDR)

Deployment Steps
Clone the Repository
git clone https://github.com/your-repo/terraform-azure-network.git
cd terraform-azure-network

Configure Variables
Modify terraform.tfvars with your environment-specific values.

Initialize Terraform

terraform init

Plan the Deployment
terraform plan

This will display the changes that Terraform will apply.

Apply the Deployment
terraform apply -auto-approve

Verify Deployment
Check Azure Portal to confirm:

The subnet is linked to NSG and Route Table.
Network rules are correctly applied.


Cleanup Resources
To destroy the infrastructure:
terraform destroy -auto-approve
