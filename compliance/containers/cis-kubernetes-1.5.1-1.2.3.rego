package datadog

import data.helpers as h

valid_process(process) {
	not h.has_key(process.flags, "--token-auth-file")
}
