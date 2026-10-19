package datadog

skip_container(c) {
	not container_running(c)
}

valid_container(c) {
	c.inspect.State.Health.Status != ""
}
