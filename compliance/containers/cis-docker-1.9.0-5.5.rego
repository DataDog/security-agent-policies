package datadog

valid_container(c) {
	not c.inspect.HostConfig.Privileged
}
