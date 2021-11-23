package datadog

valid_process(process) {
	process.flags["--peer-cert-file"] != ""
	process.flags["--peer-key-file"] != ""
}
