package datadog
import data.datadog as dd
import data.helpers as h

has_flag(p, k) {
  _ := p.flags[k]
}


compliant {
  valid_process_args(input.process)
} {
  valid_process_and_config(input.process, input.file)
}

valid_process_args(p) {
  has_flag(p, "--rotate-certificates")
  p.flags["--rotate-certificates"] != "false"
}

valid_process_and_config(p, f) {
  not has_flag(p, "--rotate-certificates")
  has_flag(p, "--config")
  f.content.rotateCertificates == true
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
