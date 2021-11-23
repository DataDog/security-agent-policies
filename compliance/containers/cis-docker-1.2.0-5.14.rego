package datadog

valid_container(c) {
	c.inspect.HostConfig.RestartPolicy.Name == "on-failure"
	c.inspect.HostConfig.RestartPolicy.MaximumRetryCount == 5
}
