package datadog
import data.datadog as dd

resources_in_default(in) {
  count(in.pods) > 0
}

resources_in_default(in) {
  count(in.services) > 0
}

findings[f] {
  not resources_in_default(input)
  f := dd.passed_finding(
    "kubernetes_cluster",
    dd.kubernetes_cluster_resource_id,
    {}
  )
} {
  resources_in_default(input)
  f := dd.failing_finding(
    "kubernetes_cluster",
    dd.kubernetes_cluster_resource_id,
    {}
  )
}
