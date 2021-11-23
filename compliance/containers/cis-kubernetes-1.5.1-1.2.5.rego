package datadog

valid_process(process) {
	process.flags["--kubelet-client-certificate"] != ""
	process.flags["--kubelet-client-key"] != ""
}
