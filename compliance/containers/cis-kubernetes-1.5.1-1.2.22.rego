package datadog

import data.helpers as h

valid_process(process) {
	h.has_key(process, "--audit-log-path")
}
