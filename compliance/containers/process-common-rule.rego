package datadog

import data.datadog as dd
import data.helpers as h

findings[f] {
	valid_process(input.process)
	f := dd.passed_finding(
		h.resource_type,
		h.resource_id,
		dd.process_data(input.process),
	)
}

findings[f] {
	not valid_process(input.process)
	f := dd.failing_finding(
		h.resource_type,
		h.resource_id,
		dd.process_data(input.process),
	)
}
