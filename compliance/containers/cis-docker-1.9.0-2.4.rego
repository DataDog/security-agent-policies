package datadog

iptables_disabled {
	is_false(daemon_setting(["--iptables"], "iptables"))
}

daemon_compliant {
	not iptables_disabled
}
