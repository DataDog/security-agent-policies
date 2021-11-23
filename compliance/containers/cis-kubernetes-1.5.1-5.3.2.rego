package datadog

import data.datadog as dd
import data.helpers as h

failed_namespaces[namespaces] {
	some i, j
	networkpolicies := input.networkpolicies[i]
	namespaces := input.namespaces[j]
	namespaces.name != networkpolicies.namespace
}

findings[f] {
	count(failed_namespaces) == 0
	f := dd.passed_finding(
		h.resource_type,
		h.resource_id,
		{},
	)
}

findings[f] {
	count(failed_namespaces) > 0
	f := dd.failing_finding(
		h.resource_type,
		h.resource_id,
		{"namespaces": [name | name := failed_namespaces[_].name]},
	)
}
