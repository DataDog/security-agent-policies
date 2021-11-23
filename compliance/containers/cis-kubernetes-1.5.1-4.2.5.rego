package datadog
import data.datadog as dd
import data.helpers as h

valid_process_args(p) {
  h.has_key(p.flags, "--streaming-connection-idle-timeout")
  to_number(p.flags["--streaming-connection-idle-timeout"]) > 0
}

valid_process_and_config(p, f) {
  not h.has_key(p.flags, "--streaming-connection-idle-timeout")
  h.has_key(p.flags, "--config")
  f.path == p.flags["--config"]
  to_number(f.content.streamingConnectionIdleTimeout) > 0
}

compliant {
  valid_process_args(input.process)
} {
  valid_process_and_config(input.process, input.file)
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
