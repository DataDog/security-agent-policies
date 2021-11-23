package datadog

valid_process(process) {
	regex.match("RotateKubeletServerCertificate=true", process.flags["--feature-gates"])
}
