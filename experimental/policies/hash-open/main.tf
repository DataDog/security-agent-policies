terraform {
  required_providers {
    datadog = {
      source = "DataDog/datadog"
      version = "3.72.0"
    }
  }
}

variable "api_key" {
  description = "Datadog API Key"
}

variable "app_key" {
  description = "Datadog App Key"
}

variable "url" {
  description = "Datadog Url"
  default = "http://app.datadoghq.com"
}

provider "datadog" {
  api_key = var.api_key
  app_key = var.app_key
  api_url = var.url
}

resource "datadog_csm_threats_policy" "experimental_hash_open" {
    description  = "Hash newly created files (experimental)"
    name         = "Hash newly created files (experimental)"
    enabled      = false
}

resource "datadog_csm_threats_agent_rule" "experimental_hash_open_host" {
    description  = "Hash newly created files"
    enabled      = true
    expression   = "open.flags & (O_CREAT|O_TRUNC|O_RDWR|O_WRONLY) > 0 && open.file.change_time < 5s && (process.file.name in [\"wget\", \"curl\", \"lwp-download\"] || process.ancestors.file.name in [\"apache2\", \"nginx\", ~\"tomcat*\", \"httpd\"])"
    name         = "experimental_hash_open_host"
    policy_id    = datadog_csm_threats_policy.experimental_hash_open.id
    product_tags = ["type:experimental"]
    actions {
      hash {}
    }
}