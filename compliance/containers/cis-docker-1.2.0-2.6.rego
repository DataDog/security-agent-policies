package datadog

import data.datadog as dd
import data.helpers as h

findings[f] {
  compliant
  f := dd.passed_finding(
    h.resource_type,
    h.resource_id,
    {}
  )
} {
  not compliant
  f := dd.failing_finding(
    h.resource_type,
    h.resource_id,
    {}
  )
}

has_key(xs, k) {
  _ = xs[k]
}

compliant {
  p := input.process
  has_key(p.flags, "--tlsverify")
  p.flags["--tlscacert"] != ""
  p.flags["--tlscert"] != ""
  p.flags["--tlskey"] != ""
}

compliant {
  p := input.process
  f := input.file
  not has_key(p.flags, "--tlsverify")
  f.content.tlsverify == true
  f.content.tlscacert != ""
  f.content.tlscert != ""
  f.content.tlskey != ""
}

compliant {
  c := input.config
  c.content.tlsverify
  c.content.tlscacert != ""
  c.content.tlscert != ""
  c.content.tlskey != ""
}
