# static website with CDN

## Requirements

### OVH CREDENTIALS
To get ovh creds, follow these steps : https://docs.ovh.com/gb/en/customer/first-steps-with-ovh-api/

To get API key directly :  https://eu.api.ovh.com/createApp/

### AZ CLI
Some resources can't be done with terraform, and uses `az cli`. To install azure CLI : https://docs.microsoft.com/fr-fr/cli/azure/install-azure-cli

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->


## Usage

```hcl
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

```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alternatives_domains"></a> [alternatives\_domains](#input\_alternatives\_domains) | List of others subdomains which the certificate will match | `list(any)` | `[]` | no |
| <a name="input_app_name"></a> [app\_name](#input\_app\_name) | The name of the hosted app for resource naming purpose | `string` | n/a | yes |
| <a name="input_cdn_content_types_to_compress"></a> [cdn\_content\_types\_to\_compress](#input\_cdn\_content\_types\_to\_compress) | List of content types to compress | `list(string)` | <pre>[<br>  "text/html",<br>  "text/css",<br>  "text/plain",<br>  "text/xml",<br>  "text/x-component",<br>  "text/javascript",<br>  "application/x-javascript",<br>  "application/javascript",<br>  "application/json",<br>  "application/manifest+json",<br>  "application/vnd.api+json",<br>  "application/xml",<br>  "application/xhtml+xml",<br>  "application/rss+xml",<br>  "application/atom+xml",<br>  "application/vnd.ms-fontobject",<br>  "application/x-font-ttf",<br>  "application/x-font-opentype",<br>  "application/x-font-truetype",<br>  "image/svg+xml",<br>  "image/x-icon",<br>  "image/vnd.microsoft.icon",<br>  "font/ttf",<br>  "font/eot",<br>  "font/otf",<br>  "font/opentype"<br>]</pre> | no |
| <a name="input_cdn_enable_compression"></a> [cdn\_enable\_compression](#input\_cdn\_enable\_compression) | Sets whether to enable compression in order to reduce bandwidth usage | `bool` | `true` | no |
| <a name="input_cdn_location"></a> [cdn\_location](#input\_cdn\_location) | Azure region where the CDN will be created | `string` | `"westeurope"` | no |
| <a name="input_cdn_public_html_path"></a> [cdn\_public\_html\_path](#input\_cdn\_public\_html\_path) | Static web hosting root directory without the trailing slash | `string` | n/a | yes |
| <a name="input_cdn_reroute_all_rules"></a> [cdn\_reroute\_all\_rules](#input\_cdn\_reroute\_all\_rules) | Additional rewrite rules for CDN endpoint, usually used with react apps | `any` | `{}` | no |
| <a name="input_domain"></a> [domain](#input\_domain) | domain for the CDN custom endpoint | `string` | `"contoso.com"` | no |
| <a name="input_index_document"></a> [index\_document](#input\_index\_document) | The name of the document (html) file to be used as index | `string` | `"index.html"` | no |
| <a name="input_location"></a> [location](#input\_location) | Azure region where the resource group is located | `string` | `"france central"` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Ressource group where the ressources will be created | `string` | n/a | yes |
| <a name="input_storage_account_settings"></a> [storage\_account\_settings](#input\_storage\_account\_settings) | Map of settings for the storage account | `map(string)` | <pre>{<br>  "account_kind": "StorageV2",<br>  "account_replication_type": "LRS",<br>  "account_tier": "Standard"<br>}</pre> | no |
| <a name="input_subdomain"></a> [subdomain](#input\_subdomain) | Sub domain for the CDN custom endpoint | `string` | `"blog"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Map of tags for resources | `map(string)` | <pre>{<br>  "environment": "test"<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_customdomainname"></a> [customdomainname](#output\_customdomainname) | List of URL(s) binded to CDN |
| <a name="output_static_website_cdn_endpoint_url"></a> [static\_website\_cdn\_endpoint\_url](#output\_static\_website\_cdn\_endpoint\_url) | CDN endpoint URL for Static website |
| <a name="output_static_website_url"></a> [static\_website\_url](#output\_static\_website\_url) | static web site URL from storage account |  
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
