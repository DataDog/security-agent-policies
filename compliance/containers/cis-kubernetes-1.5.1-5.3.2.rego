package datadog
import data.datadog as dd

failed_namespaces[namespaces] {
  some i, j
  networkpolicies := input.networkpolicies[i]
  namespaces := input.namespaces[j]
  namespaces.name != networkpolicies.namespace
}

findings[f] {
  count(failed_namespaces) == 0
  f := dd.passed_finding(
    "kubernetes_cluster",
    dd.kubernetes_cluster_resource_id,
    {}
  )
} {
  count(failed_namespaces) > 0
  f := dd.failing_finding(
    "kubernetes_cluster",
    dd.kubernetes_cluster_resource_id,
    { "namespaces": [ name | name := failed_namespaces[_].name ]}
  )
}
