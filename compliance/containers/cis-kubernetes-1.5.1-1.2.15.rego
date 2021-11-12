package datadog

valid_process(process) {
  not regex.match("NamespaceLifecycle", process.flags["--disable-admission-plugins"])
}