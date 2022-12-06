package datadog

import data.datadog as dd
import data.helpers as h

compliant(file, process) {
	# Flag supersede everything
	process.flags["--log-level"] == "info"
}

compliant(file, process) {
	# No flag But config file
	not h.has_key(process.flags, "--log-level")
	file.content["log-level"] == "info"
}

compliant(file, process) {
	# Default flag value, missing config in file
	not h.has_key(process.flags, "--log-level")
	not h.has_key(file.content, "log-level")
}

findings[f] {
	process := input.process[_]
	compliant(input.file, process)
	f := dd.passed_finding(
		"docker_daemon",
		h.docker_daemon_resource_id,
		{},
	)
}

findings[f] {
	process := input.process[_]
	not compliant(input.file, process)
	f := dd.failing_finding(
		"docker_daemon",
		h.docker_daemon_resource_id,
		{},
	)
}
