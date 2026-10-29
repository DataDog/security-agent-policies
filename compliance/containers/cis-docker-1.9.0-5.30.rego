package datadog

docker0_networks[name] {
	n := input.networks[_]
	n.inspect.Options["com.docker.network.bridge.name"] == "docker0"
	name := n.name
}

docker0_networks[name] {
	n := input.networks[_]
	n.inspect.Options["com.docker.network.bridge.default_bridge"] == "true"
	name := n.name
}

on_docker0(c) {
	some name
	c.inspect.NetworkSettings.Networks[name]
	docker0_networks[name]
}

valid_container(c) {
	not on_docker0(c)
}
