## Resource Group ##

variable "resource_group_name" {
  type        = string
  description = "Ressource group where the ressources will be created"
}

variable "location" {
  type        = string
  description = "Azure region where the resource group is located"
  default     = "france central"
}

## DNS ##

variable "domain" {
  type        = string
  default     = "contoso.com"
  description = "domain for the CDN custom endpoint"
}

variable "subdomain" {
  type        = string
  default     = "blog"
  description = "Sub domain for the CDN custom endpoint"
}

variable "alternatives_domains" {
  type        = list(any)
  default     = []
  description = "List of others subdomains which the certificate will match"
}

## Storage Account ##

variable "index_document" {
  type        = string
  description = "The name of the document (html) file to be used as index"
  default     = "index.html"
}

variable "storage_account_settings" {
  type        = map(string)
  description = "Map of settings for the storage account"
  default = {
    account_tier             = "Standard"
    account_replication_type = "LRS"
    account_kind             = "StorageV2"
  }
}

variable "storage_account_ip_whitelist" {
  type        = list(string)
  description = "List of public IP or IP ranges in CIDR Format. Only IPV4 addresses are allowed. /31 and /32 CIDR not supported"
  default     = []
}

## CDN ##

variable "cdn_location" {
  type        = string
  description = "Azure region where the CDN will be created"
  default     = "westeurope"
}

variable "cdn_public_html_path" {
  type        = string
  description = "Static web hosting root directory without the trailing slash"
}

variable "cdn_reroute_all_rules" {
  type        = any
  description = "Additional rewrite rules for CDN endpoint, usually used with react apps"
  default     = {}
}

variable "cdn_enable_compression" {
  type        = bool
  description = "Sets whether to enable compression in order to reduce bandwidth usage"
  default     = true
}

variable "cdn_content_types_to_compress" {
  type        = list(string)
  description = "List of content types to compress"
  default = [
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
}

## Misc ##

variable "app_name" {
  type        = string
  description = "The name of the hosted app for resource naming purpose"
}

## Tags ##

variable "tags" {
  type        = map(string)
  description = "Map of tags for resources"
  default = {
    "environment" = "test"
  }
}