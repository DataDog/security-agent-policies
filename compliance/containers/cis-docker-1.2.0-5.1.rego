package datadog

valid_container(c) {
	c.inspect.AppArmorProfile != "unconfined"
	c.inspect.AppArmorProfile != ""
}
