package datadog

valid_process(process) {
	process.flags["--client-cert-auth"] == "true"
}
