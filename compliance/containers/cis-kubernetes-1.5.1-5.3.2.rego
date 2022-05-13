package datadog

import data.datadog as dd
import data.helpers as h
import future.keywords.every

compliant_namespace(n) {
	np := input.networkpolicies[_]
	np.namespace == n.name
}

all_namespaces_compliant {
	every n in input.namespaces {
		compliant_namespace(n)
	}
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
