package datadog

# dockerd applies the last no-new-privileges option.
option(c) = o {
	opts := [x | x := c.inspect.HostConfig.SecurityOpt[_]; startswith(x, "no-new-privileges")]
	o := opts[count(opts) - 1]
}

valid_container(c) {
	option(c) == "no-new-privileges"
}

valid_container(c) {
	is_true(substring(option(c), count("no-new-privileges") + 1, -1))
}

valid_container(c) {
	not option(c)
	is_true(daemon_setting(["--no-new-privileges"], "no-new-privileges"))
}
