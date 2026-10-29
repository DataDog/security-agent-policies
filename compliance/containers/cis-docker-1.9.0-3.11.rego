package datadog

# dockerd reads its server certificate from --tlscert, else from tlscert in its
# configuration file. The rule judges that file when an input finds it.

tls_path = daemon_setting(["--tlscert"], "tlscert")

file_selection = p {
	p := tls_path
}

file_selection = "" {
	not tls_path
}

file_skip_reason = "dockerd names no server certificate" {
	not tls_path
}

file_skip_reason = sprintf("dockerd reads its server certificate from %s, audit it by hand", [tls_path]) {
	tls_path
	count(found_files) == 0
}
