package datadog

valid_process(process) {
	process.flags["--kubelet-certificate-authority"] != ""
}
