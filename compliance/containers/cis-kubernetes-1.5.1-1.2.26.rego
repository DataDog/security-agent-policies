package datadog

import data.helpers as h

valid_process(process) {
	# we assume that if value is explicit then it's compliant
	# default value is not ok
	h.has_key(process.flags, "--request-timeout")
}
