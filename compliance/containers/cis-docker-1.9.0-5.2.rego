package datadog

apparmor_enabled {
	startswith(input.infos[0].inspect.SecurityOptions[_], "name=apparmor")
}

skip_container(c) {
	not apparmor_enabled
}

# Docker records the profile of a container when it starts it.
skip_container(c) {
	c.inspect.State.Status == "created"
}

valid_container(c) {
	c.inspect.AppArmorProfile != ""
	c.inspect.AppArmorProfile != "unconfined"
}
