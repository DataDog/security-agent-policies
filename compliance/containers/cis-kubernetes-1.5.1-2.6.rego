package datadog

valid_process(process) {
	not process.flags["--peer-auto-tls"] == "true"
}
