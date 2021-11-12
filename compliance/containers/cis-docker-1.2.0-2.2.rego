package datadog
import data.datadog as dd

compliant_config(file) {
  file.content["log-level"] == "info"
} {
  count(file) == 0
}

compliant_process(process) {
  process.flags["--log-level"] == "info"
}

noncompliant_process(process) {
  has_key(process.flags, "--log-level")
  process.flags["--log-level"] != "info"
}

compliant(in) {
  compliant_process(in.process)
} {
  not noncompliant_process(in.process)
  compliant_config(in.file)
}

has_key(o, k) {
  _ := o[k]
}

findings[f] {
  compliant(input)
  f := dd.passed_finding(
    "docker_daemon",
    dd.docker_daemon_resource_id,
    {}
  )
} {
  not compliant(input)
  f := dd.failing_finding(
    "docker_daemon",
    dd.docker_daemon_resource_id,
    {}
  )
}
