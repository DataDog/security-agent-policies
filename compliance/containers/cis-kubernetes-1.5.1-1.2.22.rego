package datadog

has_key(p, k) {
  _ = p.flags[k]
}

valid_process(process) {
  has_key(process, "--audit-log-path")
}