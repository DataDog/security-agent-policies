package datadog

import data.datadog as dd
import data.helpers as h

valid_process_args(p) {
	h.has_key(p.flags, "--streaming-connection-idle-timeout")
	to_number(p.flags["--streaming-connection-idle-timeout"]) > 0
}

valid_process_and_config(p, f) {
	not h.has_key(p.flags, "--streaming-connection-idle-timeout")
	h.has_key(p.flags, "--config")
	f.path == p.flags["--config"]
	valid_file(f)
}

valid_file(f) {
	# matches time units like 0s, 0m, etc
	not regex.match("^0+[a-z]?$", sprintf("%v", [f.content.streamingConnectionIdleTimeout]))
}

valid_file(f) {
	not h.has_key(f.content, "streamingConnectionIdleTimeout")
}

compliant(process) {
	valid_process_args(process)
}

compliant(process) {
	valid_process_and_config(process, input.file)
}

findings[f] {
	process := input.process[_]
	compliant(process)
	f := dd.passed_finding(
		h.resource_type,
		h.resource_id,
		h.process_data(process),
	)
}

findings[f] {
	process := input.process[_]
	not compliant(process)
	f := dd.failing_finding(
		h.resource_type,
		h.resource_id,
		h.process_data(process),
	)
}
