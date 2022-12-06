package datadog

import data.datadog as dd
import data.helpers as h

compliant(process) {
	valid_process_args(process)
}

compliant(process) {
	valid_process_and_config(process, input.file)
}

valid_process_args(p) {
	h.has_key(p.flags, "--read-only-port")
	to_number(p.flags["--read-only-port"]) == 0
}

valid_process_and_config(p, f) {
	not h.has_key(p.flags, "--read-only-port")
	h.has_key(p.flags, "--config")
	f.path == p.flags["--config"]
	f.content.readOnlyPort == 0
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
