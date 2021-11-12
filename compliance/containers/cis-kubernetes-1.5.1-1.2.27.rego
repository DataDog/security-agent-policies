package datadog

valid_process(process) {
  process.flags["--service-account-lookup"] == "true"
}