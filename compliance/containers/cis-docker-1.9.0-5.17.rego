package datadog

valid_container(c) {
	c.inspect.HostConfig.IpcMode != "host"
}
