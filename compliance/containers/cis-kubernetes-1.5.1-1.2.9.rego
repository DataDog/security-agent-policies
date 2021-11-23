package datadog

valid_process(process) {
	regex.match("RBAC", process.flags["--authorization-mode"])
}
