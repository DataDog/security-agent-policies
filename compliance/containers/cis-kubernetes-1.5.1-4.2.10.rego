package datadog

import data.datadog as dd
import data.helpers as h

compliant(process) {
	valid_process_args(process)
}

compliant(process) {
	valid_process_and_config(process, input.file)
}

valid_process_args(p) {
	p.flags["--tls-cert-file"] != ""
	p.flags["--tls-private-key-file"] != ""
}

valid_process_and_config(p, f) {
	not h.has_key(p.flags, "--tls-cert-file")
	not h.has_key(p.flags, "--tls-private-key-file")
	f.path == p.flags["--config"]
	valid_config(f.content)
}

valid_config(content) {
	content.tlsCertFile != ""
	content.tlsPrivateKeyFile != ""
}

valid_config(content) {
	content.serverTLSBootstrap != ""
}

valid_config(content) {
	content.featureGates.RotateKubeletServerCertificate != ""
}

findings[f] {
	process := input.process[_]
	compliant(process)
	f := dd.passed_finding(
		h.resource_type,
		h.resource_id,
		h.process_data(process),
	)
}

findings[f] {
	process := input.process[_]
	not compliant(process)
	f := dd.failing_finding(
		h.resource_type,
		h.resource_id,
		h.process_data(process),
	)
}
