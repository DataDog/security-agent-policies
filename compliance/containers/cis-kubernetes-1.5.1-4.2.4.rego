package datadog
import data.datadog as dd

has_key(p, k) {
  _ := p.flags[k]
}


compliant {
  valid_process_args(input.process)
} {
  valid_process_and_config(input.process, input.file)
}

valid_process_args(p) {
  has_key(p, "--read-only-port")
  to_number(p.flags["--read-only-port"]) == 0
}

valid_process_and_config(p, f) {
  not has_key(p, "--read-only-port")
  has_key(p, "--config")
  f.path == p.flags["--config"]
  f.content.readOnlyPort == 0
}

findings[f] {
  compliant
  f := dd.passed_finding(
    "docker_daemon",
    dd.docker_daemon_resource_id,
    dd.process_data(input.process)
  )
} {
  not compliant
  f := dd.failing_finding(
    "docker_daemon",
    dd.docker_daemon_resource_id,
    dd.process_data(input.process)
  )
}
