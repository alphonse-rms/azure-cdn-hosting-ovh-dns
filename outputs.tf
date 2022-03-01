output "static_website_url" {
  value       = join("", ["https://", "${azurerm_storage_account.storage_account.primary_web_host}"])
  description = "static web site URL from storage account"
}

output "static_website_cdn_endpoint_url" {
  value       = join("", ["https://", "${azurerm_cdn_endpoint.endpoint.name}.", "azureedge.net"])
  description = "CDN endpoint URL for Static website"
}

output "customdomainname" {
  value       = formatlist("%s.${var.domain}", concat([var.subdomain], var.alternatives_domains))
  description = "List of URL(s) binded to CDN"
}
