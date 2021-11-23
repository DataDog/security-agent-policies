package datadog

valid_container(c) {
	c.inspect.HostConfig.CpuShares != 0
	c.inspect.HostConfig.CpuShares != 1024
}
