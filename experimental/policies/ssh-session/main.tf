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

resource "datadog_csm_threats_policy" "ssh_session" {
    description  = "SSH Session tracking"
    name         = "SSH Session tracking"
    enabled      = false
}

resource "datadog_csm_threats_agent_rule" "ssh_session_start" {
    description  = "SSH Session start"
    enabled      = true
    expression   = "exec.tty_name != \"\" && process.ancestors.name == \"sshd\" && $${process.ssh_session_key} == \"\""
    name         = "ssh_session_start"
    policy_id    = datadog_csm_threats_policy.ssh_session.id
    product_tags = ["type:experimental"]
    actions {
      set {
        name   = "ssh_session_key"
        #expression = "'\"ssh_$${builtins.uuid4}\"'"
        scope = "process"
        #inherited = true
      }
    }
}

resource "datadog_csm_threats_agent_rule" "ssh_session" {
    description  = "SSH Session start"
    enabled      = true
    expression   = "exec.file.name != \"\" && $${process.ssh_session_key} != \"\""
    name         = "ssh_session"
    policy_id    = datadog_csm_threats_policy.ssh_session.id
    product_tags = ["type:experimental"]
}
