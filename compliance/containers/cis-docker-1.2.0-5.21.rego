package datadog

invalid_seccomp(c) {
	c.inspect.HostConfig.SecurityOpt[_] == "seccomp:unconfined"
}

valid_container(c) {
	not invalid_seccomp(c)
}
