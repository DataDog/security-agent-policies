package datadog

import data.datadog as dd
import data.helpers as h

compliant {
	valid_process_args(input.process)
}

compliant {
	valid_process_and_config(input.process, input.file)
}

valid_process_args(p) {
	h.has_key(p.flags, "--rotate-certificates")
	p.flags["--rotate-certificates"] != "false"
}

valid_process_and_config(p, f) {
	not h.has_key(p.flags, "--rotate-certificates")
	h.has_key(p.flags, "--config")
	valid_file(f)
}

valid_file(f) {
	f.content.rotateCertificates != false
}

valid_file(f) {
	not h.has_key(f.content, "rotateCertificates")
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
