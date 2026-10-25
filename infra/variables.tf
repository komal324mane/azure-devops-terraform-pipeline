variable "resource_group_name" {
  description = "Name for the demo resource group. Applying creates a real Azure resource."
  type        = string
  default     = "rg-terraform-pipeline-lab"
}

variable "location" {
  description = "Azure region."
  type        = string
  default     = "Central India"
}

variable "environment" {
  description = "Environment tag."
  type        = string
  default     = "dev"
}
