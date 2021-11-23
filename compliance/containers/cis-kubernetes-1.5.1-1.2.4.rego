package datadog
import data.helpers as h

valid_process(process) {
  not h.has_key(process.flags, "--kubelet-https")
} {
  process.flags["--kubelet-https"] == "true"
}
