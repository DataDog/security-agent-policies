package datadog

level = daemon_setting(["-l", "--log-level"], "log-level")

debug {
	is_true(daemon_setting(["-D", "--debug"], "debug"))
}

daemon_compliant {
	not level
	not debug
}

daemon_compliant {
	lower(level) == "info"
	not debug
}

daemon_data = {"daemon.log_level": level}
