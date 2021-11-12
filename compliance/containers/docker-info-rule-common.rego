package datadog
import data.datadog as dd


findings[f] {
  count([i | i := input.infos[_]; valid_info(i)]) == count(input.infos[_])
  f := dd.passed_finding(
    "docker_daemon",
    dd.docker_daemon_resource_id,
    {}
  )
} {
  count([i | i := input.infos[_]; valid_info(i)]) != count(input.infos[_])
  f := dd.failing_finding(
    "docker_daemon",
    dd.docker_daemon_resource_id,
    {}
  )
}
