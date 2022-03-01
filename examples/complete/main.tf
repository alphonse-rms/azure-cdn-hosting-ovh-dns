provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy    = false
      recover_soft_deleted_key_vaults = true
    }
  }
}

provider "ovh" {
  endpoint = "ovh-eu"
}

module "azure_static_website_with_ovh_dns" {
  source = "../../"

  location                      = var.location
  app_name                      = var.app_name
  resource_group_name           = var.resource_group_name
  domain                        = var.domain
  subdomain                     = var.subdomain
  alternatives_domains          = var.alternatives_domains
  cdn_location                  = var.cdn_location
  cdn_public_html_path          = "${path.cwd}/${var.cdn_public_html_path}"
  cdn_reroute_all_rules         = var.cdn_reroute_all_rules
  cdn_enable_compression        = var.cdn_enable_compression
  cdn_content_types_to_compress = var.cdn_content_types_to_compress
  tags                          = var.tags
}
