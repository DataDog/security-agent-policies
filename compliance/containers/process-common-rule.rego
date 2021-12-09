package datadog

import data.datadog as dd
import data.helpers as h

findings[f] {
	valid_process(input.process)
	f := dd.passed_finding(
		h.resource_type,
		h.resource_id,
		h.process_data(input.process),
	)
}

findings[f] {
	not valid_process(input.process)
	f := dd.failing_finding(
		h.resource_type,
		h.resource_id,
		h.process_data(input.process),
	)
}

findings[f] {
	count(input.process) == 0
	f := dd.error_finding(
		h.resource_type,
		h.resource_id,
		sprintf("no process found for process check \"%s\"", [input.context.input.process.process.name]),
	)
}

findings[f] {
	not h.has_key(input, "process")
	f := dd.error_finding(
		h.resource_type,
		h.resource_id,
		sprintf("failed to resolve process name: %s", [input.context.input.process.process.name]),
	)
}
