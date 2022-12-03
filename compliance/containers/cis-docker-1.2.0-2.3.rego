package datadog

import data.datadog as dd
import data.helpers as h

compliant_config(file) {
	file.content.iptables == false
}

compliant_process(process) {
	process.flags["--iptables"] == "false"
}

# default value is true
# https://docs.docker.com/engine/reference/commandline/dockerd/
noncompliant_process(process) {
	h.has_key(process.flags, "--iptables")
	process.flags["--iptables"] != "false"
}

compliant(process, file) {
	compliant_process(process)
}

compliant(process, file) {
	not noncompliant_process(process)
	compliant_config(file)
}

# cli args take precedence
findings[f] {
	process := input.process[_]
	file := input.file
	compliant(process, file)
	f := dd.passed_finding(
		h.resource_type,
		h.resource_id,
		{},
	)
}

findings[f] {
	process := input.process[_]
	file := input.file
	not compliant(process, file)
	f := dd.failing_finding(
		h.resource_type,
		h.resource_id,
		{},
	)
}

findings[f] {
	# if dockerd process doesn't exist then error
	count(input.process) == 0
	f := dd.error_finding(
		h.resource_type,
		h.resource_id,
		"process resource does not exist",
	)
}
