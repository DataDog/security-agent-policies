package datadog

valid_container(c) {
	c.inspect.HostConfig.SecurityOpt[_] == "no-new-privileges"
}
