package datadog

valid_process(process) {
  process.flags["--auto-tls"] != "true"
}