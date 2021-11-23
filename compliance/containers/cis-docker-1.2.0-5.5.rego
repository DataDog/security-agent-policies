package datadog

invalid_mounts(c) {
	bannedMounts := [
		"/",
		"/boot",
		"/dev",
		"/etc",
		"/lib",
		"/proc",
		"/sys",
		"/usr",
	]

	c.inspect.HostConfig.Mounts[_].Source == bannedMounts[_]
}

valid_container(c) {
	not invalid_mounts(c)
}
