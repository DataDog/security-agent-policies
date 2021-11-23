package datadog

valid_container(c) {
	c.inspect.State.Health.Status != ""
}
