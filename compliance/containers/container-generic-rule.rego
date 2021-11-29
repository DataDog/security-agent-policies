package datadog

import data.datadog as dd
import data.helpers as h

findings[f] {
	c := input.containers[_]
	valid_container(c)
	f := dd.passed_finding(
		h.resource_type,
		h.docker_container_resource_id(c),
		h.docker_container_data(c),
	)
}

findings[f] {
	c := input.containers[_]
	not valid_container(c)
	f := dd.failing_finding(
		h.resource_type,
		h.docker_container_resource_id(c),
		h.docker_container_data(c),
	)
}
