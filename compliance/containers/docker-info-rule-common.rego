package datadog

import data.datadog as dd
import data.helpers as h
import future.keywords.every

all_infos_valid {
	every i in input.infos {
		valid_info(i)
	}
}

findings[f] {
	all_infos_valid
	f := dd.passed_finding(
		h.resource_type,
		h.resource_id,
		{},
	)
}

findings[f] {
	not all_infos_valid
	f := dd.failing_finding(
		h.resource_type,
		h.resource_id,
		{},
	)
}
