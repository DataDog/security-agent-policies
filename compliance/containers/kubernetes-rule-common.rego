package datadog

namespaces := input.namespaces[_]

kubernetes_resource_qualified_names(serviceaccounts) = x {
	x := [{"name": name, "namespace": namespace} |
		name := serviceaccounts.name
		namespace := serviceaccounts.namespace
	]
}

kubernetes_resource_names(serviceaccounts) = x {
	x := [{"name": name, "namespace": namespace} |
		name := serviceaccounts.name
		namespace := serviceaccounts.namespace
	]
}
