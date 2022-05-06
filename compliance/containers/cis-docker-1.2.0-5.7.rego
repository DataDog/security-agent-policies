package datadog

import future.keywords.every

invalid_port(p) {
	to_number(split(p, "/")[0]) < 1024
}

valid_container(c) {
	every portKey, _ in c.inspect.NetworkSettings.Ports {
		not invalid_port(portKey)
	}
}
