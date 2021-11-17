package datadog
import data.datadog as dd
import data.helpers as h

has_key(p, k) {
  _ := p.flags[k]
}

compliant {
  valid_process_args(input.process)
} {
  valid_process_and_config(input.process, input.file)
}

valid_process_args(p) {
  not has_key(p, "--config")
  p.flags["--tlskey"] != ""
  p.flags["--tls-cert-file"]  != ""
  p.flags["--tls-private-key-file"] != ""
}

valid_process_and_config(p, f) {
  not has_key(p, "--tls-cert-file")
  not has_key(p, "--tls-private-key-file")
  f.path == p.flags["--config"]
  valid_config(f.content)
}

valid_config(content) {
  content.tlsCertFile != ""
  content.tlsPrivateKeyFile != ""
} {
  content.serverTLSBootstrap != ""
  content.featureGates.RotateKubeletServerCertificate != ""
}

findings[f] {
  compliant
  f := dd.passed_finding(
    h.resource_type,
    h.resource_id,
    dd.process_data(input.process)
  )
} {
  not compliant
  f := dd.failing_finding(
    h.resource_type,
    h.resource_id,
    dd.process_data(input.process)
  )
}
