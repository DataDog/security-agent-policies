package datadog
import data.datadog as dd

findings[f] {
   user_in_group(input.group)
   f := dd.passed_finding(
     "docker_daemon",
     dd.docker_daemon_resource_id,
     dd.group_data(input.group)
   )
} {
   not user_in_group(input.group)
   f := dd.failing_finding(
     "docker_daemon",
     dd.docker_daemon_resource_id,
     dd.group_data(input.group)
   )

}

user_in_group(group) {
  count([u | u := group.users[_]; u == "docker"]) == 1
}
