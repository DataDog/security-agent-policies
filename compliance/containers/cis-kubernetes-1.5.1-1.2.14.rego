package datadog

valid_process(process) {
  not regex.match("ServiceAccount", process.flags["--disable-admission-plugins"])
}