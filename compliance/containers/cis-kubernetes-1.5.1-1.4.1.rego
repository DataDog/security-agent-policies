package datadog

valid_process(process) {
	process.flags["--profiling"] == "false"
}
