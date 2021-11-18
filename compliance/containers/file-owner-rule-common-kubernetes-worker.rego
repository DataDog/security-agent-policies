package datadog
import data.datadog as dd

findings[f] {
  compliant
  f := dd.passed_finding(
    "kubernetes_worker_node",
    dd.kubernetes_worker_node_resource_id,
    dd.file_data(input.file)
  )
}

findings[f] {
  not compliant
  f := dd.failing_finding(
    "kubernetes_worker_node",
    dd.kubernetes_worker_node_resource_id,
    dd.file_data(input.file)
  )
}

compliant {
 file := input.file
 file.user == input.constants.user;
 file.group == input.constants.group
}
