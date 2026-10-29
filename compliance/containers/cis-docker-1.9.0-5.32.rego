package datadog

docker_socket_mount(c) {
	m := c.inspect.Mounts[_]
	endswith(m.Source, "/docker.sock")
}

docker_socket_mount(c) {
	m := c.inspect.Mounts[_]
	endswith(m.Destination, "/docker.sock")
}

# A bind of /, /run or /var/run exposes the socket too.
docker_socket_mount(c) {
	m := c.inspect.Mounts[_]
	m.Type == "bind"
	{"/", "/run", "/var/run"}[m.Source]
}

valid_container(c) {
	datadog_agent_image(c)
}

valid_container(c) {
	not docker_socket_mount(c)
}
