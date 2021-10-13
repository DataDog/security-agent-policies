package docker_audit

import data.datadog as dd

findings[f] {
  audit = input.audit[_]
  audit.enabled
  f := dd.passed_finding(
    "docker_daemon",
    dd.docker_daemon_resource_id,
    dd.audit_data(audit)
  )
} {
  f := dd.failing_finding(
    "docker_daemon",
    dd.docker_daemon_resource_id,
    {}
  )
}
