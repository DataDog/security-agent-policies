package datadog

invalid_mount(c) {
	c.inspect.Mounts[_].Source == "/var/run/docker.sock"
}

valid_container(c) {
	not invalid_mount(c)
}
