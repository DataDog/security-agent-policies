package datadog
import data.datadog as dd

findings[f] {
  c := input.containers[_]
  valid_container(c)
  f := dd.passed_finding(
    "docker_container",
     dd.docker_container_resource_id(c),
     dd.docker_container_data(c)
  )
} {
  c := input.containers[_]
  not valid_container(c)
  f := dd.failing_finding(
    "docker_container",
    dd.docker_container_resource_id(c),
    dd.docker_container_data(c)
    )
}
