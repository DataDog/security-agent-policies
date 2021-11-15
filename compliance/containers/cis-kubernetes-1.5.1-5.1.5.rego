package datadog
import data.datadog as dd

failed_clusterrolebindings[serviceaccount] {
  serviceaccount := input.serviceaccounts[_]
  clusterrolebinding := input.clusterrolebindings[_]
  clusterrolebinding.resource.Object.subjects[i].kind == "ServiceAccount"
  clusterrolebinding.resource.Object.subjects[i].namespace == serviceaccount.namespace
  clusterrolebinding.resource.Object.subjects[i].name == serviceaccount.name
}

failed_rolebindings[serviceaccount] {
  serviceaccount := input.serviceaccounts[_]
  rolebinding := input.rolebindings[_]
  rolebinding.resource.Object.subjects[i].kind == "ServiceAccount"
  rolebinding.resource.Object.subjects[i].namespace == serviceaccount.namespace
  rolebinding.resource.Object.subjects[i].name == serviceaccount.name
}

service_account_with_token[serviceaccount] {
  serviceaccount := input.serviceaccounts[_]
  serviceaccount.resource.Object.automountServiceAccountToken == true
}

findings[f] {
  count(input.serviceaccounts) == 0
  f := dd.passed_finding(
    "kubernetes_cluster",
    dd.kubernetes_cluster_resource_id,
    { "reason": "no service account" }
  )
} {
  count(service_account_with_token) > 0
  f := dd.failing_finding(
    "kubernetes_cluster",
    dd.kubernetes_cluster_resource_id,
    { "reason": "automountServiceAccountToken is set",
      "serviceAccounts": kubernetes_resource_names(service_account_with_token[_]) }
  )
} {
  count(failed_clusterrolebindings) > 0
  f := dd.failing_finding(
    "kubernetes_cluster",
    dd.kubernetes_cluster_resource_id,
    { "reason": "incorrect cluster role bindings",
      "serviceAccounts": kubernetes_resource_names(failed_clusterrolebindings[_]) }
  )
} {
  count(failed_rolebindings) > 0
  f := dd.failing_finding(
    "kubernetes_cluster",
    dd.kubernetes_cluster_resource_id,
    { "reason": "incorrect role bindings",
      "serviceAccounts": kubernetes_resource_names(failed_rolebindings[_]) }
  )
} {
  count(input.serviceaccounts) > 0
  count(service_account_with_token) == 0
  count(failed_clusterrolebindings) == 0
  count(failed_rolebindings) == 0
  f := dd.passed_finding(
    "kubernetes_cluster",
    dd.kubernetes_cluster_resource_id,
    {}
  )
}
