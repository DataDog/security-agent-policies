package datadog

# With user namespace remapping, the daemon keeps its data in a
# subdirectory of the data root named after the remapped user and group,
# such as /var/lib/docker/100000.100000.
remapped(i) {
	startswith(i.inspect.SecurityOptions[_], "name=userns")
	regex.match(`/[0-9]+\.[0-9]+$`, i.inspect.DockerRootDir)
}

data_root = root {
	i := input.infos[0]
	not remapped(i)
	root := i.inspect.DockerRootDir
}

data_root = root {
	i := input.infos[0]
	remapped(i)
	parts := split(i.inspect.DockerRootDir, "/")
	root := concat("/", array.slice(parts, 0, count(parts) - 1))
}

audit_skip_reason = reason {
	data_root != "/var/lib/docker"
	reason := sprintf("the data root is %s, audit it by hand", [data_root])
}
