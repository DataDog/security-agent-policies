package datadog

valid_process(process) {
	not regex.match("AlwaysAllow", process.flags["--authorization-mode"])
}
