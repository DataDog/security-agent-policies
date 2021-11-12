package datadog

valid_process(process) {
  not regex.match("AlwaysAdmit", process.flags["--enable-admission-plugins"])
}