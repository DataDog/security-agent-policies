package datadog

import data.helpers as h

valid_process(process) {
	not h.has_key(process.flags, "--authorization-mode")
}

valid_process(process) {
	not regex.match("AlwaysAllow", process.flags["--authorization-mode"])
}
