package datadog

import data.datadog as dd
import data.helpers as h

findings[f] {
	count([p | p := input.policies[_]; p.resource.Object.spec.hostNetwork != true]) > 0
	f := dd.passed_finding(
		h.resource_type,
		h.resource_id,
		{},
	)
}

findings[f] {
	count([p | p := input.policies[_]; p.resource.Object.spec.hostNetwork != true]) == 0
	f := dd.failing_finding(
		h.resource_type,
		h.resource_id,
		{},
	)
}
