package datadog

valid_process(process) {
	regex.match("PodSecurityPolicy", process.flags["--enable-admission-plugins"])
}
