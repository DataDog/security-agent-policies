package datadog

valid_container(c) {
	c.inspect.Config.User != ""
}
