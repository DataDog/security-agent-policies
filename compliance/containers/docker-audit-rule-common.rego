package datadog

import data.datadog as dd
import data.helpers as h

# An audit rule reads one pair of inputs per path the recommendation
# accepts: auditN lists the watches on the path, and fileN tells whether
# the path exists. The agent gives no audit input both for a missing path
# and for a path without a watch. A rule that defines audit_selection
# counts only the paths in that set.

default audit_skip_reason = ""

default audit_selection = {"*"}

selected_path(_) {
	audit_selection["*"]
}

selected_path(p) {
	audit_selection[p]
}

watched_paths[p] {
	some k, i
	startswith(k, "audit")
	w := input[k][i]
	w.enabled
	p := w.path
	selected_path(p)
}

existing_paths[p] {
	some k
	startswith(k, "file")
	p := input[k].path
}

present_paths[p] {
	p := existing_paths[_]
	selected_path(p)
}

findings[f] {
	audit_skip_reason == ""
	count(watched_paths) > 0
	f := dd.passed_finding(
		h.resource_type,
		h.resource_id,
		{"audit.paths": sort(watched_paths)},
	)
}

findings[f] {
	audit_skip_reason == ""
	count(watched_paths) == 0
	count(present_paths) > 0
	f := dd.failing_finding(
		h.resource_type,
		h.resource_id,
		{"file.paths": sort(present_paths)},
	)
}

findings[f] {
	audit_skip_reason == ""
	count(watched_paths) == 0
	count(present_paths) == 0
	f := dd.skipped_finding(
		h.resource_type,
		h.resource_id,
		"no audited path exists",
	)
}

findings[f] {
	audit_skip_reason != ""
	f := dd.skipped_finding(
		h.resource_type,
		h.resource_id,
		audit_skip_reason,
	)
}
