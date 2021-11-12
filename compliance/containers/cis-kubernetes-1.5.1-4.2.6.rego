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
  has_key(p, "--protect-kernel-defaults")
  lower(p.flags["--protect-kernel-defaults"]) == "true"
}

valid_process_and_config(p, f) {
  not has_key(p, "--protect-kernel-defaults")
  has_key(p, "--config")
  f.path == p.flags["--config"]
  f.content.protectKernelDefaults
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
