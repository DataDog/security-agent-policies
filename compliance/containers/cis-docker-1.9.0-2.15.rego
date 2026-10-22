package datadog

daemon_compliant {
	is_true(daemon_setting(["--no-new-privileges"], "no-new-privileges"))
}
