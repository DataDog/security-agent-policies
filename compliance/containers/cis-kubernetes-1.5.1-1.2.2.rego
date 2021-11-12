package datadog

has_key(p, k) {
  _ = p.flags[k]
}

valid_process(process) {
  not has_key(process, "--basic-auth-file")
}