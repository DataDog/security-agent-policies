package datadog

valid_process(process) {
	regex.match("NodeRestriction", process.flags["--enable-admission-plugins"])
}
