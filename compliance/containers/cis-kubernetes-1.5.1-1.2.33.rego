package datadog

valid_process(process) {
	process.flags["--encryption-provider-config"] != ""
}
