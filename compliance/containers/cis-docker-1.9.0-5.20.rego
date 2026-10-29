package datadog

shared_mount(c) {
	m := c.inspect.Mounts[_]
	m.Propagation == "shared"
}

shared_mount(c) {
	m := c.inspect.Mounts[_]
	m.Propagation == "rshared"
}

valid_container(c) {
	not shared_mount(c)
}
