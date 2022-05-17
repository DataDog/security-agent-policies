package datadog

import data.datadog as dd
import data.helpers as h

resources_in_default {
	count(input.pods) > 0
}

resources_in_default {
	count(input.services) > 0
}

findings[f] {
	not resources_in_default
	f := dd.passed_finding(
		h.resource_type,
		h.resource_id,
		{},
	)
}

findings[f] {
	resources_in_default
	f := dd.failing_finding(
		h.resource_type,
		h.resource_id,
		{},
	)
}
