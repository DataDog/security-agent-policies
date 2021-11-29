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
	to_number(f.content.streamingConnectionIdleTimeout) != 0
}

valid_file(f) {
	not h.has_key(f.content, "streamingConnectionIdleTimeout")
}

compliant {
	valid_process_args(input.process)
}

compliant {
	valid_process_and_config(input.process, input.file)
}

findings[f] {
	compliant
	f := dd.passed_finding(
		h.resource_type,
		h.resource_id,
		h.process_data(input.process),
	)
}

findings[f] {
	not compliant
	f := dd.failing_finding(
		h.resource_type,
		h.resource_id,
		h.process_data(input.process),
	)
}
