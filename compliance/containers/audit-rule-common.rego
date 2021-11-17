package datadog

import data.datadog as dd
import data.helpers as h

has_key(o, k) {
  _ := o[k]
}

findings[f] {
  count([audit | audit := input.audit[_]; audit.enabled]) > 0
  f := dd.passed_finding(
    h.resource_type,
    h.resource_id,
    h.audit_data(input.audit[0])
  )
} {
  has_key(input, "audit")
  count([audit | audit := input.audit[_]; audit.enabled]) == 0
  f := dd.failing_finding(
    h.resource_type,
    h.resource_id,
    {}
  )
} {
  not has_key(input, "audit")
  f := dd.error_finding(
    h.resource_type,
    h.resource_id,
    sprintf("%s: audit resource path does not exist", [input.context.ruleID])
  )
}

