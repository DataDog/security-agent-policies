package datadog

valid_process(process) {
	process.flags["--cert-file"] != ""
	process.flags["--key-file"] != ""
}
