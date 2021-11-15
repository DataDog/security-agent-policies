package datadog
import data.datadog as dd

findings[f] {
  count([p | p := input.policies[_]; p.resource.Object.spec.hostPID!=true]) > 0
  f := dd.passed_finding(
    "kubernetes_cluster",
    dd.kubernetes_cluster_resource_id,
    {}
  )
} {
  count([p | p := input.policies[_]; p.resource.Object.spec.hostPID!=true]) == 0
  f := dd.failing_finding(
    "kubernetes_cluster",
    dd.kubernetes_cluster_resource_id,
    {}
  )
}
