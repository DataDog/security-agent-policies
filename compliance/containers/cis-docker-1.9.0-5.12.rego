package datadog

valid_container(c) {
	shares := c.inspect.HostConfig.CpuShares
	shares != 0
	shares != 1024
}
