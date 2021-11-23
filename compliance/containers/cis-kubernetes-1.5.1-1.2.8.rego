package datadog

valid_process(process) {
	regex.match("Node", process.flags["--authorization-mode"])
}
