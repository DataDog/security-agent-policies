package datadog

valid_process(process) {
	process.flags["--peer-client-cert-auth"] == "true"
}
