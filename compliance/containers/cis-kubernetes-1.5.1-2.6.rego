package datadog

valid_process(process) {
  process.flags["--peer-auto-tls"] != "true"
}