package datadog

import data.datadog as dd

has_key(o, k) {
  _ := o[k]
}

findings[f] {
  count([audit | audit := input.audit[_]; audit.enabled]) > 0
  f := dd.passed_finding(
    "docker_daemon",
    dd.docker_daemon_resource_id,
    dd.audit_data(input.audit[0])
  )
} {
  has_key(input, "audit")
  count([audit | audit := input.audit[_]; audit.enabled]) == 0
  f := dd.failing_finding(
    "docker_daemon",
    dd.docker_daemon_resource_id,
    {}
  )
} {
  not has_key(input, "audit")
  f := dd.error_finding(
    "docker_daemon",
    dd.docker_daemon_resource_id,
    sprintf("%s: audit resource path does not exist", [input.context.ruleID])
  )
}

