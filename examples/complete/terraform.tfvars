## Naming & Tags##
app_name = "andrana"
tags = {
  "environment" = "test"
}

## Resource Group ##
resource_group_name = "DefaultResourceGroup-WE"
location            = "france central"

## Storage Account ##
storage_account_settings = {
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
}

## CDN ##
cdn_location         = "westeurope"
cdn_public_html_path = "files"
cdn_reroute_all_rules = {
  all = {
    name  = "ReRouteAll"
    order = "2"
  }
}
cdn_enable_compression = true
cdn_content_types_to_compress = [
  "text/html",
  "text/css",
  "text/plain",
  "text/xml",
  "text/x-component",
  "text/javascript",
  "application/x-javascript",
  "application/javascript",
  "application/json",
  "application/manifest+json",
  "application/vnd.api+json",
  "application/xml",
  "application/xhtml+xml",
  "application/rss+xml",
  "application/atom+xml",
  "application/vnd.ms-fontobject",
  "application/x-font-ttf",
  "application/x-font-opentype",
  "application/x-font-truetype",
  "image/svg+xml",
  "image/x-icon",
  "image/vnd.microsoft.icon",
  "font/ttf",
  "font/eot",
  "font/otf",
  "font/opentype"
]
index_document = "index.html"

## DNS ##
domain    = "keltio.fr"
subdomain = "cdna-alphonse"

