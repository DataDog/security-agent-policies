package datadog

valid_process(process) {
	process.flags["--tls-cert-file"] != ""
	process.flags["--tls-private-key-file"] != ""
}
