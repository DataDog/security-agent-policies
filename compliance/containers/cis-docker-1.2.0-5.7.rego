package datadog

invalid_port(p) {
	to_number(split(p, "/")[0]) < 1024
}

valid_container(c) {
	count([p | p := c.inspect.NetworkSettings.Ports[portKey]; invalid_port(portKey)]) == 0
}
