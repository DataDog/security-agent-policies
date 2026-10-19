package datadog

daemon_compliant {
	is_false(daemon_setting(["--userland-proxy"], "userland-proxy"))
}
