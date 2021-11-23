package datadog

valid_process(process) {
	process.flags["--etcd-certfile"] != ""
	process.flags["--etcd-keyfile"] != ""
}
