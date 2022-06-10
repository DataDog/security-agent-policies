package datadog

import data.datadog as dd
import data.helpers as h

compliant_psp(p) {
	p.resource.Object.spec[input.constants.spec] != true
}

compliant_psp(p) {
	not h.has_key(p.resource.Object.spec, input.constants.spec)
}

compliant_policies = [p | p := input.policies[_]; compliant_psp(p)]

findings[f] {
	count(compliant_policies) > 0
	f := dd.passed_finding(
		h.resource_type,
		h.resource_id,
		{},
	)
}

findings[f] {
	count(compliant_policies) == 0
	f := dd.failing_finding(
		h.resource_type,
		h.resource_id,
		{},
	)
}
