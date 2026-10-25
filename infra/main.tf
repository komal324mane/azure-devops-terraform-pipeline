resource "azurerm_resource_group" "pipeline_demo" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    project     = "azure-devops-terraform-pipeline"
    environment = var.environment
    managed_by  = "terraform"
  }
}
