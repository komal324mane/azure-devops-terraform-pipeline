output "resource_group_name" {
  description = "Name of the resource group managed by this pipeline example."
  value       = azurerm_resource_group.pipeline_demo.name
}
