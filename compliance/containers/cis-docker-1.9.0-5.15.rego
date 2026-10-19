package datadog

valid_container(c) {
	c.inspect.HostConfig.RestartPolicy.Name == "no"
}

valid_container(c) {
	c.inspect.HostConfig.RestartPolicy.Name == ""
}

valid_container(c) {
	policy := c.inspect.HostConfig.RestartPolicy
	policy.Name == "on-failure"
	policy.MaximumRetryCount >= 1
	policy.MaximumRetryCount <= 5
}
