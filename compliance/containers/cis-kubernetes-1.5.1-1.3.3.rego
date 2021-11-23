package datadog

valid_process(process) {
	process.flags["--use-service-account-credentials"] == "true"
}
