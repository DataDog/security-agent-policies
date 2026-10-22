package datadog

# dockerd reads its TLS CA certificate from --tlscacert, else from tlscacert in its
# configuration file. The rule judges that file when an input finds it.

tls_path = daemon_setting(["--tlscacert"], "tlscacert")

file_selection = p {
	p := tls_path
}

file_selection = "" {
	not tls_path
}

file_skip_reason = "dockerd names no TLS CA certificate" {
	not tls_path
}

file_skip_reason = sprintf("dockerd reads its TLS CA certificate from %s, audit it by hand", [tls_path]) {
	tls_path
	count(found_files) == 0
}
