package datadog

valid_process(process) {
	process.flags["--etcd-cafile"] != ""
}
