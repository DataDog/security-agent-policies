package datadog

import data.helpers as h

valid_process(process) {
	not h.has_key(process.flags, "--service-account-lookup")
}

valid_process(process) {
	process.flags["--service-account-lookup"] == "true"
}
