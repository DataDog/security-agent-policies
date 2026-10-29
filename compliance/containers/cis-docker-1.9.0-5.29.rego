package datadog

skip_container(c) {
	not container_running(c)
}

valid_container(c) {
	limit := c.inspect.HostConfig.PidsLimit
	is_number(limit)
	limit > 0
}
