package datadog

valid_process(process) {
	process.flags["--audit-policy-file"] != ""
}
