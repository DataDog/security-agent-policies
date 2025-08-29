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

resource "datadog_csm_threats_agent_rule" "hash_exec_host" {
    description  = "Hash binary at the execution"
    enabled      = true
    expression   = "process.container.id == \"\" && exec.file.name != \"\" && exec.file.path not in $${host_already_sent_hashes}"
    name         = "hash_exec_host"
    policy_id    = datadog_csm_threats_policy.hash_exec.id
    product_tags = ["type:experimental"]
    actions {
      set {
        name   = "host_already_sent_hashes"
        field  = "exec.file.path"
        append = true
        ttl = 3600000000000
      }
    }
}

resource "datadog_csm_threats_agent_rule" "hash_exec_container" {
    description  = "Hash binary at the execution"
    enabled      = true
    expression   = "exec.file.in_upper_layer == true && process.container.id != \"\" && exec.file.name != \"\" && exec.file.path not in $${cgroup.cont_already_sent_hashes}"
    name         = "hash_exec_container"
    policy_id    = datadog_csm_threats_policy.hash_exec.id
    product_tags = ["type:experimental"]
    actions {
      set {
        name   = "cont_already_sent_hashes"
        field  = "exec.file.path"
        append = true
        scope  = "cgroup"
        ttl = 3600000000000
      }
    }
}
