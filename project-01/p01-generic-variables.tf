variable "environment" {
  type        = string
  description = "This variable defines the environment to be built"
  default     = "dev"
}

# azure region
variable "location" {
  type        = string
  description = "Azure region where the resource group will be created"
  default     = "centralus"
}

variable "resource_group_name" {
  type        = string
  description = "Resource Group Name"
  default     = "sameer-rg"
}

variable "creation_source" {
  type        = string
  description = "Creation Source"
  default     = "Terraform"
}