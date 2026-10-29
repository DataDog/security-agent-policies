package datadog

skip_container(c) {
	not container_running(c)
}

user_name(c) = u {
	u := split(c.inspect.Config.User, ":")[0]
}

valid_container(c) {
	u := user_name(c)
	u != ""
	u != "root"
	not zero_uid(u)
}

# Docker reads a numeric user as a UID, so 00 and +0 are root too.
zero_uid(u) {
	to_number(u) == 0
}
