package datadog

import data.datadog as dd
import data.helpers as h

max_permissions(file, consts) {
	file.permissions == bits.and(file.permissions, parse_octal(consts.max_permissions))
}

all_files_ok(in) {
	count([f | f := in.files[_]; max_permissions(f, in.constants)]) == count(in.files)
}

findings[f] {
	count(input.files) > 0
	all_files_ok(input)
	f := dd.passed_finding(
		h.resource_type,
		h.resource_id,
		{"files": [h.file_data(f) | f := input.files[_]]},
	)
}

findings[f] {
	count(input.files) > 0
	not all_files_ok(input)
	f := dd.failing_finding(
		h.resource_type,
		h.resource_id,
		{"files": [h.file_data(f) | f := input.files[_]]},
	)
}

findings[f] {
	count(input.files) == 0
	f := dd.skipped_finding(
		h.resource_type,
		h.resource_id,
		sprintf("no files found for file check \"%s\"", [input.context.input.files.file.path]),
	)
}

findings[f] {
	not h.has_key(input, "files")
	f := dd.skipped_finding(
		h.resource_type,
		h.resource_id,
		sprintf("no files found for file check \"%s\"", [input.context.input.files.file.path]),
	)
}
