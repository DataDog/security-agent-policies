package datadog

skip_container(c) {
	not container_running(c)
}

privileged_port(c) {
	b := c.inspect.NetworkSettings.Ports[_][_]
	to_number(b.HostPort) < 1024
}

valid_container(c) {
	not privileged_port(c)
}
