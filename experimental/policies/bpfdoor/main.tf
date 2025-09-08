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

resource "datadog_csm_threats_policy" "experimental_bpfdoor" {
    description  = "Detect BPFDoor (experimental)"
    name         = "Detect BPFDoor (experimental)"
    enabled      = false
}

resource "datadog_csm_threats_agent_rule" "experimental_bpfdoor_pid_file_creation" {
    description  = "A pid file have been created in /var/run, this could be the first step of the BPFDoor malware."
    enabled      = true
    expression   = "open.file.path in [\"/var/run/haldrund.pid\", \"/var/run/hald-smartd.pid\", \"/var/run/system.pid\", \"/var/run/hp-health.pid\", \"/var/run/hald-addon.pid\", \"/run/haldrund.pid\", \"/run/hald-smartd.pid\", \"/run/system.pid\", \"/run/hp-health.pid\", \"/run/hald-addon.pid\"] && open.flags & O_CREAT != 0"
    name         = "experimental_bpfdoor_pid_file_creation"
    policy_id    = datadog_csm_threats_policy.experimental_bpfdoor.id
    product_tags = ["type:experimental"]
    actions {
      set {
        name   = "pid_file"
        value  = "true"
        ttl    = 10000000000
        scope  = "process"
      }
    }
}

resource "datadog_csm_threats_agent_rule" "experimental_bpfdoor_bpf_filter_creation" {
    description  = "BPFDoor malware detected: a BPF filter has been attached to a socket and previously a fake pid file has been created."
    enabled      = true
    expression   = "setsockopt.level == SOL_SOCKET && setsockopt.optname == SO_ATTACH_FILTER && $${process.pid_file} == \"true\""
    name         = "experimental_bpfdoor_bpf_filter_creation"
    policy_id    = datadog_csm_threats_policy.experimental_bpfdoor.id
    product_tags = ["type:experimental"]
    actions {
      set {
        name   = "pid_file"
        value  = "true"
        ttl    = 10000000000
        scope  = "process"
      }
    }
}
