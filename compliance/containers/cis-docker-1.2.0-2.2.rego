package datadog
import data.datadog as dd
import data.helpers as h

compliant(file, process){
  # Flag supersede everything
  process.flags["--log-level"] == "info"
}{
  # No flag But config file
  not h.has_key(process.flags, "--log-level")
  file.content["log-level"] == "info"
}{
  # Default flag value, missing config in file
  not h.has_key(process.flags, "--log-level")
  not h.has_key(file.content, "log-level")
}

findings[f] {
  compliant(input.file, input.process)
  f := dd.passed_finding(
    "docker_daemon",
    dd.docker_daemon_resource_id,
    {}
  )
}{
  not compliant(input.file, input.process)
  f := dd.failing_finding(
    "docker_daemon",
    dd.docker_daemon_resource_id,
    {}
  )
}
