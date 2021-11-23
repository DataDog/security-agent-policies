package datadog

valid_process(process) {
	not process.flags["--auto-tls"] == "true"
}
