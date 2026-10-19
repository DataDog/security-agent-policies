package datadog

default_capabilities = {
	"AUDIT_WRITE", "CHOWN", "DAC_OVERRIDE", "FOWNER", "FSETID", "KILL",
	"MKNOD", "NET_BIND_SERVICE", "NET_RAW", "SETFCAP", "SETGID", "SETPCAP",
	"SETUID", "SYS_CHROOT",
}

capability(name) = c {
	c := trim_prefix(upper(name), "CAP_")
}

dropped(c, name) {
	capability(c.inspect.HostConfig.CapDrop[_]) == name
}

added(c, name) {
	capability(c.inspect.HostConfig.CapAdd[_]) == name
}

net_raw_dropped(c) {
	dropped(c, "NET_RAW")
	not added(c, "NET_RAW")
	not added(c, "ALL")
}

net_raw_dropped(c) {
	dropped(c, "ALL")
	not added(c, "NET_RAW")
	not added(c, "ALL")
}

extra_capability(c) {
	name := capability(c.inspect.HostConfig.CapAdd[_])
	not default_capabilities[name]
}

valid_container(c) {
	not c.inspect.HostConfig.Privileged
	net_raw_dropped(c)
	not extra_capability(c)
}
