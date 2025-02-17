package datadog

import future.keywords.in

allow_list_container_images = {
	"datadog/agent",
	"datadog/cluster-agent",
}

invalid_mount(c) {
	c.inspect.Mounts[_].Source == "/var/run/docker.sock"
}

valid_container(c) {
	c.image_repo in allow_list_container_images
}

valid_container(c) {
	not invalid_mount(c)
}
