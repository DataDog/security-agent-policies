package datadog

sensitive_directories = {"/", "/boot", "/dev", "/etc", "/lib", "/lib64", "/proc", "/sys", "/usr"}

sensitive_mount(c) {
	m := c.inspect.Mounts[_]
	m.Type == "bind"
	sensitive_directories[m.Source]
}

sensitive_mount(c) {
	m := c.inspect.Mounts[_]
	m.Type == "bind"
	m.RW == true
	d := sensitive_directories[_]
	d != "/"
	startswith(m.Source, concat("", [d, "/"]))
}

valid_container(c) {
	datadog_agent_image(c)
}

valid_container(c) {
	not sensitive_mount(c)
}
