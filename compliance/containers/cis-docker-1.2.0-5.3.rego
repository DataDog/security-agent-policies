package datadog

invalid_cap(c) {
	bannedCaps := [
		"AUDIT_WRITE",
		"CHOWN",
		"DAC_OVERRIDE",
		"FOWNER",
		"FSETID",
		"KILL",
		"MKNOD",
		"NET_BIND_SERVICE",
		"NET_RAW",
		"SETFCAP",
		"SETGID",
		"SETPCAP",
		"SETUID",
		"SYS_CHROOT",
	]

	c.inspect.HostConfig.CapAdd[_] == bannedCaps[_]
}

valid_container(c) {
	not invalid_cap(c)
}
