package datadog

valid_process(process) {
	process.flags["--root-ca-file"] != ""
}
