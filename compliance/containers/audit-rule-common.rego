package datadog

import data.datadog as dd
import data.helpers as h

enabled_audits = [audit | audit := input.audit[_]; audit.enabled]

findings[f] {
	count(enabled_audits) > 0
	f := dd.passed_finding(
		h.resource_type,
		h.resource_id,
		h.audit_data(input.audit[0]),
	)
}

findings[f] {
	h.has_key(input, "audit")
	count(enabled_audits) == 0
	f := dd.failing_finding(
		h.resource_type,
		h.resource_id,
		{},
	)
}

findings[f] {
	not h.has_key(input, "audit")
	f := dd.error_finding(
		h.resource_type,
		h.resource_id,
		sprintf("%s: audit resource path does not exist", [input.context.ruleID]),
	)
}
