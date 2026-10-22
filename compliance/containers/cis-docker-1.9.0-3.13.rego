package datadog

# dockerd reads its server key from --tlskey, else from tlskey in its
# configuration file. The rule judges that file when an input finds it.

tls_path = daemon_setting(["--tlskey"], "tlskey")

file_selection = p {
	p := tls_path
}

file_selection = "" {
	not tls_path
}

file_skip_reason = "dockerd names no server key" {
	not tls_path
}

file_skip_reason = sprintf("dockerd reads its server key from %s, audit it by hand", [tls_path]) {
	tls_path
	count(found_files) == 0
}
