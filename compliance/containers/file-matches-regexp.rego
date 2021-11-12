package datadog
import data.datadog as dd

match(file, const) {
  regex.match(const.regexp, file.content)
}

findings[f] {
  match(input.file, input.constants)
  f := dd.passed_finding(
    "docker_daemon",
    dd.docker_daemon_resource_id,
    dd.file_data(input.file)
  )
}


findings[f] {
  not match(input.file, input.constants)
  f := dd.failing_finding(
    "docker_daemon",
    dd.docker_daemon_resource_id,
    dd.file_data(input.file)
  )
}
