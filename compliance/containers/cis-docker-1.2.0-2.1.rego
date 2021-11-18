package datadog
import data.datadog as dd
import data.helpers as h

has_key(o, k) {
  _ := o[k]
}

compliant_network(network) {
  network.inspect.Options["com.docker.network.bridge.default_bridge"] != "true"
} {
  not has_key(network.inspect.Options, "com.docker.network.bridge.default_bridge")
}{
  network.inspect.Options["com.docker.network.bridge.enable_icc"] = "true"
}{
  not has_key(network.inspect.Options, "com.docker.network.bridge.enable_icc")
}

findings[f] {
  network := input.networks[_]
  compliant_network(network)
  f := dd.passed_finding(
    h.resource_type,
    dd.docker_network_resource_id(network),
    dd.docker_network_data(network)
  )
} {
  network := input.networks[_]
  not compliant_network(network)
  f := dd.failing_finding(
    h.resource_type,
    dd.docker_network_resource_id(network),
    dd.docker_network_data(network)
  )
}
