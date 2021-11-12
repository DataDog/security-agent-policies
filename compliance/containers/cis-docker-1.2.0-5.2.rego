package datadog
import data.datadog as dd

has_key(o, k) {
  _ := o[k]
}

valid_container(c) {
  c.inspect.HostConfig.SecurityOpt[_] == "selinux"
}

selinux_enabled(in) {
  input.file.content == "1"
}

findings[f] {
  selinux_enabled(input)
  c := input.containers[_]
  valid_container(c)
  f := dd.passed_finding(
    "docker_container",
     dd.docker_container_resource_id(c),
     dd.docker_container_data(c)
  )
} {
  selinux_enabled(input)
  c := input.containers[_]
  not valid_container(c)
  f := dd.failing_finding(
    "docker_container",
    dd.docker_container_resource_id(c),
    dd.docker_container_data(c)
    )
} {
  # if the selinux is disabled output error finding to ignore this rule in the mapper
  not selinux_enabled(input)
  f := dd.error_finding(
    "docker_daemon",
    dd.docker_daemon_resource_id,
    "selinux is disabled"
  )
}
