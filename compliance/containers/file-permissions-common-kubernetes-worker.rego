package datadog
import data.datadog as dd


max_permissions(file, consts) {
  file.permissions == bits.and(file.permissions, parse_octal(consts.max_permissions))
}

findings[f] {
  max_permissions(input.file, input.constants)
  f := dd.passed_finding(
    "kubernetes_worker_node",
    dd.kubernetes_worker_node_resource_id,
    dd.file_data(input.file)
  )
}


findings[f] {
  not max_permissions(input.file, input.constants)
  f := dd.failing_finding(
    "kubernetes_worker_node",
    dd.kubernetes_worker_node_resource_id,
    dd.file_data(input.file)
  )
}

