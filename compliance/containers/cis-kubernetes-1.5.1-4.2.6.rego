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
	h.has_key(p.flags, "--protect-kernel-defaults")
	lower(p.flags["--protect-kernel-defaults"]) == "true"
}

valid_process_and_config(p, f) {
	not h.has_key(p.flags, "--protect-kernel-defaults")
	h.has_key(p.flags, "--config")
	f.path == p.flags["--config"]
	f.content.protectKernelDefaults
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
