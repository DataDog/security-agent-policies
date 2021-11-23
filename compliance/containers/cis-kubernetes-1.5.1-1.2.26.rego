package datadog

valid_process(process) {
  not process.flags["--request-timeout"] == ""
}