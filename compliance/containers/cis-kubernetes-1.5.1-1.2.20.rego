package datadog

import data.helpers as h

valid_process(process) {
	not h.has_key(process.flags, "--secure-port")
}

valid_process(process) {
	process.flags["--secure-port"] != "0"
}
