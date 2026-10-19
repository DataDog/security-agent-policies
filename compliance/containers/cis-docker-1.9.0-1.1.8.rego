package datadog

# dockerd talks to the containerd that --containerd or daemon.json names,
# else to the system containerd when its socket exists, else to the
# containerd it starts itself. The rule judges that socket, under /run or
# /var/run.

system_sockets = {"/run/containerd/containerd.sock", "/var/run/containerd/containerd.sock"}

managed_sockets = {"/run/docker/containerd/containerd.sock", "/var/run/docker/containerd/containerd.sock"}

configured = p {
	p := trim_prefix(daemon_setting(["--containerd"], "containerd"), "unix://")
	p != ""
}

system_running {
	existing_paths[system_sockets[_]]
}

audit_selection = system_sockets {
	system_sockets[configured]
}

audit_selection = managed_sockets {
	managed_sockets[configured]
}

audit_selection = system_sockets {
	not configured
	system_running
}

audit_selection = managed_sockets {
	not configured
	not system_running
}

audit_skip_reason = sprintf("dockerd uses the containerd socket %s, audit it by hand", [configured]) {
	configured
	not system_sockets[configured]
	not managed_sockets[configured]
}
