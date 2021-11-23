package datadog

valid_container(c) {
	is_number(c.inspect.HostConfig.PidsLimit)
	c.inspect.HostConfig.PidsLimit > 0
}
