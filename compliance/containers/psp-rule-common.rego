package datadog

import data.datadog as dd
import data.helpers as h
import future.keywords.in

compliant_psp(p) {
	p.resource.Object.spec[input.constants.spec] != true
}

compliant_psp(p) {
	not h.has_key(p.resource.Object.spec, input.constants.spec)
}

at_least_one_compliant_policy {
	some p in input.policies
	compliant_psp(p)
}

findings[f] {
	at_least_one_compliant_policy
	f := dd.passed_finding(
		h.resource_type,
		h.resource_id,
		{},
	)
}

findings[f] {
	not at_least_one_compliant_policy
	f := dd.failing_finding(
		h.resource_type,
		h.resource_id,
		{},
	)
}
