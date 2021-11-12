package datadog
import data.datadog as dd

findings[f] {
  valid_process(input.process)
  f := dd.passed_finding(
    "docker_daemon",
    dd.docker_daemon_resource_id,
    dd.process_data(input.process)
  )
} {
  not valid_process(input.process)
  f := dd.failing_finding(
    "docker_daemon",
    dd.docker_daemon_resource_id,
    dd.process_data(input.process)
  )
}
