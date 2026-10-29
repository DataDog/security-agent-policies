package datadog

import data.datadog as dd
import data.helpers as h

# An info rule defines valid_info, and info_skip_reason when the
# recommendation applies to some daemons alone.

default info_skip_reason = ""

valid_infos = [i | i := input.infos[_]; valid_info(i)]

findings[f] {
	info_skip_reason == ""
	count(valid_infos) == count(input.infos)
	f := dd.passed_finding(
		h.resource_type,
		h.resource_id,
		{},
	)
}

findings[f] {
	info_skip_reason == ""
	count(valid_infos) != count(input.infos)
	f := dd.failing_finding(
		h.resource_type,
		h.resource_id,
		{},
	)
}

findings[f] {
	info_skip_reason != ""
	f := dd.skipped_finding(
		h.resource_type,
		h.resource_id,
		info_skip_reason,
	)
}
