package datadog

selinux_enforcing {
	trim_space(input.selinux.content) == "1"
}

skip_container(c) {
	not selinux_enforcing
}

label_disabled(c) {
	o := c.inspect.HostConfig.SecurityOpt[_]
	o == "label=disable"
}

label_disabled(c) {
	o := c.inspect.HostConfig.SecurityOpt[_]
	o == "label:disable"
}

# spc_t and unconfined_t run the container without confinement.
unconfined_label(c) {
	t := split(c.inspect.ProcessLabel, ":")[2]
	{"spc_t", "unconfined_t"}[t]
}

valid_container(c) {
	c.inspect.ProcessLabel != ""
	not label_disabled(c)
	not unconfined_label(c)
}
