package datadog

import data.datadog as dd
import data.helpers as h

compliant {
	valid_process_args(input.process)
}

compliant {
	valid_process_and_config(input.process, input.file)
}

valid_process_args(p) {
	not h.has_key(p.flags, "--config")
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
	compliant
	f := dd.passed_finding(
		h.resource_type,
		h.resource_id,
		dd.process_data(input.process),
	)
}

findings[f] {
	not compliant
	f := dd.failing_finding(
		h.resource_type,
		h.resource_id,
		dd.process_data(input.process),
	)
}
