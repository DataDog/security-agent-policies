package datadog

import data.datadog as dd
import data.helpers as h

findings[f] {
	v := input.versions[_]
	not v.experimental
	f := dd.passed_finding(
		h.resource_type,
		h.resource_id,
		{"docker.version": v.version},
	)
}

findings[f] {
	v := input.versions[_]
	v.experimental == true
	f := dd.failing_finding(
		h.resource_type,
		h.resource_id,
		{"docker.version": v.version},
	)
}
