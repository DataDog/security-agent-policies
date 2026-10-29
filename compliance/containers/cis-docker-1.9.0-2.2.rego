package datadog

import data.datadog as dd
import data.helpers as h

default_bridge(n) {
	n.inspect.Options["com.docker.network.bridge.default_bridge"] == "true"
}

icc_disabled(n) {
	n.inspect.Options["com.docker.network.bridge.enable_icc"] == "false"
}

findings[f] {
	n := input.networks[_]
	default_bridge(n)
	icc_disabled(n)
	f := dd.passed_finding(
		h.resource_type,
		h.docker_network_resource_id(n),
		h.docker_network_data(n),
	)
}

findings[f] {
	n := input.networks[_]
	default_bridge(n)
	not icc_disabled(n)
	f := dd.failing_finding(
		h.resource_type,
		h.docker_network_resource_id(n),
		h.docker_network_data(n),
	)
}

findings[f] {
	count([n | n := input.networks[_]; default_bridge(n)]) == 0
	f := dd.skipped_finding(
		"docker_daemon",
		h.docker_daemon_resource_id,
		"the daemon has no default bridge network",
	)
}
