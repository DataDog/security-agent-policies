package datadog

import data.datadog as dd
import data.helpers as h

compliant_network(network) {
	network.inspect.Options["com.docker.network.bridge.default_bridge"] != "true"
}

compliant_network(network) {
	not h.has_key(network.inspect.Options, "com.docker.network.bridge.default_bridge")
}

compliant_network(network) {
	network.inspect.Options["com.docker.network.bridge.enable_icc"] = "true"
}

compliant_network(network) {
	not h.has_key(network.inspect.Options, "com.docker.network.bridge.enable_icc")
}

findings[f] {
	network := input.networks[_]
	compliant_network(network)
	f := dd.passed_finding(
		h.resource_type,
		h.docker_network_resource_id(network),
		h.docker_network_data(network),
	)
}

findings[f] {
	network := input.networks[_]
	not compliant_network(network)
	f := dd.failing_finding(
		h.resource_type,
		h.docker_network_resource_id(network),
		h.docker_network_data(network),
	)
}
