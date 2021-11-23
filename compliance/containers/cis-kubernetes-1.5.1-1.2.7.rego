package datadog

valid_process(process) {
	process.flags["--authorization-mode"] != "AlwaysAllow"
}
