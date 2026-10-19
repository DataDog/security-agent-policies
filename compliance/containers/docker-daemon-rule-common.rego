package datadog

import data.datadog as dd
import data.helpers as h

# A daemon rule defines daemon_compliant, and daemon_skip_reason when the
# recommendation applies to some daemons alone.

default daemon_skip_reason = ""

default daemon_data = {}

dockerd_found {
	count(input.process) > 0
}

findings[f] {
	dockerd_found
	daemon_skip_reason == ""
	daemon_compliant
	f := dd.passed_finding(
		h.resource_type,
		h.resource_id,
		daemon_data,
	)
}

findings[f] {
	dockerd_found
	daemon_skip_reason == ""
	not daemon_compliant
	f := dd.failing_finding(
		h.resource_type,
		h.resource_id,
		daemon_data,
	)
}

findings[f] {
	dockerd_found
	daemon_skip_reason != ""
	f := dd.skipped_finding(
		h.resource_type,
		h.resource_id,
		daemon_skip_reason,
	)
}

findings[f] {
	not dockerd_found
	f := dd.error_finding(
		h.resource_type,
		h.resource_id,
		"dockerd process not found",
	)
}
