resource "random_string" "suffix" {
  length  = 5
  special = false
  upper   = false
}

data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

## STORAGE ACCOUNT ##

resource "azurerm_storage_account" "storage_account" {
  name                     = replace("${var.app_name}${random_string.suffix.result}", "/[[:punct:]]*/", "")
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = var.storage_account_settings["account_tier"]
  account_replication_type = var.storage_account_settings["account_replication_type"]
  account_kind             = var.storage_account_settings["account_kind"]
  min_tls_version          = "TLS1_2"

  static_website {
    index_document     = var.index_document
    error_404_document = var.index_document
  }

  tags = var.tags
}

resource "azurerm_storage_account_network_rules" "storage_account_network_rules" {
  storage_account_id = azurerm_storage_account.storage_account.id

  default_action = "Deny"
  ip_rules       = var.storage_account_ip_whitelist
  bypass         = ["Metrics", "AzureServices", "Logging"]
}

resource "null_resource" "blob_upload" {
  provisioner "local-exec" {
    command     = <<EOT
      az storage blob upload-batch \
        --account-name ${azurerm_storage_account.storage_account.name} \
        -d '$web' -s ${var.cdn_public_html_path}/.
    EOT
    interpreter = ["bash", "-c"]
    working_dir = path.module
  }
}

## CONTENT DELIVERY NETWORK ##

resource "azurerm_cdn_profile" "profile" {
  name                = "${var.app_name}-cdn"
  location            = var.cdn_location
  resource_group_name = var.resource_group_name
  sku                 = "Standard_Microsoft"

  tags = var.tags
}

resource "azurerm_cdn_endpoint" "endpoint" {
  name                      = azurerm_cdn_profile.profile.name
  profile_name              = azurerm_cdn_profile.profile.name
  location                  = azurerm_cdn_profile.profile.location
  resource_group_name       = var.resource_group_name
  origin_host_header        = azurerm_storage_account.storage_account.primary_web_host
  is_compression_enabled    = var.cdn_enable_compression
  content_types_to_compress = var.cdn_content_types_to_compress

  origin {
    name      = "${var.app_name}-blob-origin"
    host_name = azurerm_storage_account.storage_account.primary_web_host
  }

  delivery_rule {
    name  = "EnforceHTTPS"
    order = "1"

    request_scheme_condition {
      operator     = "Equal"
      match_values = ["HTTP"]
    }

    url_redirect_action {
      redirect_type = "Found"
      protocol      = "Https"
    }
  }

  dynamic "delivery_rule" {
    for_each = var.cdn_reroute_all_rules

    content {
      name  = delivery_rule.value["name"]
      order = delivery_rule.value["order"]

      url_file_extension_condition {
        operator     = "LessThan"
        match_values = ["1"]
      }

      url_rewrite_action {
        destination             = "/index.html"
        preserve_unmatched_path = "false"
        source_pattern          = "/"
      }
    }
  }

  tags = var.tags
}

resource "ovh_domain_zone_record" "record" {
  for_each = toset(concat([var.subdomain], var.alternatives_domains))

  zone      = var.domain
  subdomain = each.key
  fieldtype = "CNAME"
  ttl       = "3600"
  target    = format("%s.", azurerm_cdn_endpoint.endpoint.host_name)
}

resource "null_resource" "dns_record_check" {
  for_each = toset(concat([var.subdomain], var.alternatives_domains))

  provisioner "local-exec" {
    command     = "until host ${each.key}.${var.domain} > /dev/null; do echo 'Waiting for DNS propagation'; sleep 10; done"
    interpreter = ["bash", "-c"]
    working_dir = path.module
  }

  depends_on = [ovh_domain_zone_record.record]
}

resource "null_resource" "add_custom_domain" {
  for_each = toset(concat([var.subdomain], var.alternatives_domains))

  provisioner "local-exec" {
    command     = <<EOT
      az cdn custom-domain create \
        --endpoint-name ${azurerm_cdn_endpoint.endpoint.name} \
        --hostname ${each.key}.${var.domain} \
        --resource-group ${var.resource_group_name} \
        --profile-name ${azurerm_cdn_profile.profile.name} \
        --name ${replace(trim("${each.key}.${var.domain}", "."), ".", "-")} && \
      az cdn custom-domain enable-https \
        --endpoint-name ${azurerm_cdn_endpoint.endpoint.name} \
        --resource-group ${var.resource_group_name} \
        --profile-name ${azurerm_cdn_profile.profile.name} \
        --name ${replace(trim("${each.key}.${var.domain}", "."), ".", "-")}
    EOT
    interpreter = ["bash", "-c"]
    working_dir = path.module
  }

  depends_on = [
    null_resource.dns_record_check,
    ovh_domain_zone_record.record,
    azurerm_cdn_profile.profile,
    azurerm_cdn_endpoint.endpoint
  ]
}
