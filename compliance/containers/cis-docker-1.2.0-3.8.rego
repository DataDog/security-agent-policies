package datadog

import data.datadog as dd
import data.helpers as h
import future.keywords.every

max_permissions(file) {
	file.permissions == bits.and(file.permissions, parse_octal(input.constants.max_permissions))
}

all_files_ok {
	every f in input.files {
		max_permissions(f)
	}
}

findings[f] {
	count(input.files) > 0
	all_files_ok
	f := dd.passed_finding(
		h.resource_type,
		h.resource_id,
		{"files": [h.file_data(f) | f := input.files[_]]},
	)
}

findings[f] {
	count(input.files) > 0
	not all_files_ok
	f := dd.failing_finding(
		h.resource_type,
		h.resource_id,
		{"files": [h.file_data(f) | f := input.files[_]]},
	)
}

findings[f] {
	count(input.files) == 0
	f := dd.error_finding(
		h.resource_type,
		h.resource_id,
		sprintf("no files found for file check \"%s\"", [input.context.input.files.file.path]),
	)
}

findings[f] {
	not h.has_key(input, "files")
	f := dd.error_finding(
		h.resource_type,
		h.resource_id,
		sprintf("no files found for file check \"%s\"", [input.context.input.files.file.path]),
	)
}
