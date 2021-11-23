package datadog

valid_process(process) {
	process.flags["--service-account-private-key-file"] != ""
}
