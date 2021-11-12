package datadog

has_key(p, k) {
  _ = p.flags[k]
}

valid_process(process) {
  not has_key(process, "--kubelet-https")
}

valid_process(process) {
  process.flags["--kubelet-https"] == "true"
}
