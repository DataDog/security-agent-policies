package datadog

import data.datadog as dd
import data.helpers as h

findings[f] {
	count([i | i := input.infos[_]; valid_info(i)]) == count(input.infos[_])
	f := dd.passed_finding(
		h.resource_type,
		h.resource_id,
		{},
	)
}

findings[f] {
	count([i | i := input.infos[_]; valid_info(i)]) != count(input.infos[_])
	f := dd.failing_finding(
		h.resource_type,
		h.resource_id,
		{},
	)
}
