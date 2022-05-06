package datadog

import data.datadog as dd
import data.helpers as h
import future.keywords.in

findings[f] {
	user_in_group(input.group)
	f := dd.passed_finding(
		h.resource_type,
		h.resource_id,
		h.group_data(input.group),
	)
}

findings[f] {
	not user_in_group(input.group)
	f := dd.failing_finding(
		h.resource_type,
		h.resource_id,
		h.group_data(input.group),
	)
}

user_in_group(group) {
	"docker" in group.users
}
