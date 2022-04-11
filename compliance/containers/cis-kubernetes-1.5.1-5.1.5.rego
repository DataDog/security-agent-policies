package datadog

import data.datadog as dd
import data.helpers as h

clusterrolebinding_serviceaccount_subjects = [subject |
	subject := input.clusterrolebindings[_].resource.Object.subjects[_]
	subject.kind == "ServiceAccount"
]

failed_clusterrolebindings[serviceaccount] {
	serviceaccount := input.serviceaccounts[_]
	clusterrolebinding_serviceaccount_subjects[i].namespace == serviceaccount.namespace
	clusterrolebinding_serviceaccount_subjects[i].name == serviceaccount.name
}

rolebinding_serviceaccount_subjects = [subject |
	subject := input.rolebindings[_].resource.Object.subjects[_]
	subject.kind == "ServiceAccount"
]

failed_rolebindings[serviceaccount] {
	serviceaccount := input.serviceaccounts[_]
	rolebinding_serviceaccount_subjects[i].namespace == serviceaccount.namespace
	rolebinding_serviceaccount_subjects[i].name == serviceaccount.name
}

invalid_serviceaccount(serviceaccount) {
	serviceaccount.resource.Object.automountServiceAccountToken == true
}

invalid_serviceaccount(serviceaccount) {
	not h.has_key(serviceaccount.resource.Object, "automountServiceAccountToken")
}

service_account_with_token[serviceaccount] {
	serviceaccount := input.serviceaccounts[_]
	invalid_serviceaccount(serviceaccount)
}

findings[f] {
	count(input.serviceaccounts) == 0
	f := dd.passed_finding(
		h.resource_type,
		h.resource_id,
		{"reason": "no service account"},
	)
}

findings[f] {
	count(service_account_with_token) > 0
	f := dd.failing_finding(
		h.resource_type,
		h.resource_id,
		{
			"reason": "automountServiceAccountToken is set",
			"serviceAccounts": h.kubernetes_resource_names(service_account_with_token[_]),
		},
	)
}

findings[f] {
	count(failed_clusterrolebindings) > 0
	f := dd.failing_finding(
		h.resource_type,
		h.resource_id,
		{
			"reason": "incorrect cluster role bindings",
			"serviceAccounts": h.kubernetes_resource_names(failed_clusterrolebindings[_]),
		},
	)
}

findings[f] {
	count(failed_rolebindings) > 0
	f := dd.failing_finding(
		h.resource_type,
		h.resource_id,
		{
			"reason": "incorrect role bindings",
			"serviceAccounts": h.kubernetes_resource_names(failed_rolebindings[_]),
		},
	)
}

findings[f] {
	count(input.serviceaccounts) > 0
	count(service_account_with_token) == 0
	count(failed_clusterrolebindings) == 0
	count(failed_rolebindings) == 0
	f := dd.passed_finding(
		h.resource_type,
		h.resource_id,
		{},
	)
}
