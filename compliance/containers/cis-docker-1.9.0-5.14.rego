package datadog

skip_container(c) {
	not container_running(c)
}

all_interfaces = {"", "0.0.0.0", "::"}

unbound_port(c) {
	b := c.inspect.NetworkSettings.Ports[_][_]
	all_interfaces[b.HostIp]
}

valid_container(c) {
	not unbound_port(c)
}
