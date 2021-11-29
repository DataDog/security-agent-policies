package datadog

import data.datadog as dd
import data.helpers as h

valid_process_args(p) {
	h.has_key(p.flags, "--make-iptables-util-chains")
	lower(p.flags["--make-iptables-util-chains"]) == "true"
}

valid_process_args(p) {
	not h.has_key(p.flags, "--make-iptables-util-chains")
	not h.has_key(p.flags, "--config")
}

valid_process_and_config(p, f) {
	not h.has_key(p.flags, "--make-iptables-util-chains")
	h.has_key(p.flags, "--config")
	f.path == p.flags["--config"]
	valid_config(f)
}

valid_config(f) {
	f.content.makeIPTablesUtilChains
}

valid_config(f) {
	not h.has_key(f.content, "makeIPTablesUtilChains")
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
