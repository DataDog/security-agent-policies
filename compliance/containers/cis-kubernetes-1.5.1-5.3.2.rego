package datadog

import data.datadog as dd
import data.helpers as h

compliant_namespace(n) {
	np := input.networkpolicies[_]
	np.namespace == n.name
}

all_namespaces_compliant {
	count([n | n := input.namespaces[_]; compliant_namespace(n)]) == count(input.namespaces)
}

findings[f] {
	all_namespaces_compliant
	f := dd.passed_finding(
		h.resource_type,
		h.resource_id,
		{},
	)
}

findings[f] {
	not all_namespaces_compliant
	f := dd.failing_finding(
		h.resource_type,
		h.resource_id,
		{"namespaces": [n.name | n := input.namespaces[_]; not compliant_namespace(n)]},
	)
}
