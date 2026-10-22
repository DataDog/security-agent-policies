package datadog

mapped_device(c) {
	c.inspect.HostConfig.Devices[_]
}

# --gpus and CDI device names give device requests.
mapped_device(c) {
	c.inspect.HostConfig.DeviceRequests[_]
}

mapped_device(c) {
	c.inspect.HostConfig.DeviceCgroupRules[_]
}

valid_container(c) {
	not mapped_device(c)
}
