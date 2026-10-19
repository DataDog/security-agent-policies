package datadog

# dockerd applies the last seccomp option, which it splits on = and
# then on :.
profile(c) = p {
	opts := [o | o := c.inspect.HostConfig.SecurityOpt[_]; startswith(o, "seccomp")]
	p := substring(opts[count(opts) - 1], count("seccomp") + 1, -1)
}

# A container that names no profile takes the default of the daemon.
daemon_unconfined {
	input.infos[0].inspect.SecurityOptions[_] == "name=seccomp,profile=unconfined"
}

valid_container(c) {
	profile(c) != "unconfined"
}

valid_container(c) {
	not profile(c)
	not daemon_unconfined
}
