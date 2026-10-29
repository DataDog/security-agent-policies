package datadog

valid_info(i) {
	i.inspect.Swarm.LocalNodeState == "inactive"
}

valid_info(i) {
	i.inspect.Swarm.LocalNodeState == ""
}
