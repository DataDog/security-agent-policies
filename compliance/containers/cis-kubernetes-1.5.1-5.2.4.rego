package datadog
import data.datadog as dd

findings[f] {
  input.policies[_].resource.Object.spec.hostNetwork
  f := dd.passed_finding(
    "docker_daemon",
    dd.docker_daemon_resource_id,
    {}
  )
} {
  f := dd.failing_finding(
    "docker_daemon",
    dd.docker_daemon_resource_id,
    {}
  )
}
