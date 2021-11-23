package datadog

valid_process(process) {
	process.flags["--bind-address"] == "127.0.0.1"
}
