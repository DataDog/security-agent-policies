package datadog
import data.datadog as dd

has_key(o, k) {
  _ := o[k]
}

findings[f] {
  file := input.file
  compliant(file)
  f := dd.passed_finding(
    "docker_daemon",
    dd.docker_daemon_resource_id,
    dd.file_data(input.file)
  )
} {
  file := input.file
  not compliant(file)
  f := dd.failing_finding(
    "docker_daemon",
    dd.docker_daemon_resource_id,
    dd.file_data(input.file)
  )
} {
  count(input.file) == 0
  f := dd.error_finding(
    "docker_daemon",
    dd.docker_daemon_resource_id,
    sprintf("no files found for file check \"%s\"", [input.context.input.file.file.path])
  )
} {
  not has_key(input, "file")
  f := dd.error_finding(
    "docker_daemon",
    dd.docker_daemon_resource_id,
    sprintf("failed to resolve path: empty path from %s", [input.context.input.file.file.path])
  )
}

compliant(file) {
 file.user == input.constants.user;
 file.group == input.constants.group
}
