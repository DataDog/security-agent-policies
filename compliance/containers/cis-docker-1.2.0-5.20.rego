package datadog

valid_container(c) {
	c.inspect.HostConfig.UTSMode != "host"
}
