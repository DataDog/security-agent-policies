package datadog
import data.helpers as h

valid_process(process) {
  not h.has_key(process.flags, "--enable-admission-plugins")
} {
  not regex.match("AlwaysAdmit", process.flags["--enable-admission-plugins"])
}