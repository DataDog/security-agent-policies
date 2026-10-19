package datadog

valid_info(i) {
	startswith(i.inspect.SecurityOptions[_], "name=userns")
}

valid_info(i) {
	startswith(i.inspect.SecurityOptions[_], "name=rootless")
}
