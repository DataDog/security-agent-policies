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

resource "datadog_csm_threats_policy" "hash_exec" {
    description  = "Hash binary at the execution"
    name         = "Hash binary at the execution"
    enabled      = false
}

resource "datadog_csm_threats_agent_rule" "hash_exec" {
    description  = "Hash binary at the execution"
    enabled      = true
    expression   = "exec.file.name != \"\" && exec.file.path not in $${cgroup.already_sent_hashes}"
    name         = "hash_exec"
    policy_id    = datadog_csm_threats_policy.hash_exec.id
    product_tags = ["type:experimental"]
    actions {
      set {
        name   = "already_sent_hashes"
        field  = "exec.file.path"
        append = true
        scope  = "cgroup"
        ttl = 60000000000
      }
    }
}
