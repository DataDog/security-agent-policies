package datadog

valid_process(process) {
	process.flags["--anonymous-auth"] == "false"
}
