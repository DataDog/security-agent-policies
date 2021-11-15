package datadog
import data.datadog as dd

findings[f] {
  valid_process(input.process)
  f := dd.passed_finding(
    "kubernetes_worker_node",
    dd.kubernetes_worker_node_resource_id,
    dd.process_data(input.process)
  )
} {
  not valid_process(input.process)
  f := dd.failing_finding(
    "kubernetes_worker_node",
    dd.kubernetes_worker_node_resource_id,
    dd.process_data(input.process)
  )
}
