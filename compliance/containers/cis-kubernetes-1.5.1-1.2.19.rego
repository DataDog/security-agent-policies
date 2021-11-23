package datadog

valid_process(process) {
	process.flags["--insecure-port"] == "0"
}
