package datadog

import data.datadog as dd
import data.helpers as h

match(file, const) {
	regex.match(const.regexp, file.content)
}

findings[f] {
	match(input.file, input.constants)
	f := dd.passed_finding(
		h.resource_type,
		h.resource_id,
		h.file_data(input.file),
	)
}

findings[f] {
	not match(input.file, input.constants)
	f := dd.failing_finding(
		h.resource_type,
		h.resource_id,
		h.file_data(input.file),
	)
}
