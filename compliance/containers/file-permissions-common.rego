package datadog

import data.datadog as dd
import data.helpers as h

max_permissions(file, consts) {
	file.permissions == bits.and(file.permissions, parse_octal(consts.max_permissions))
}

findings[f] {
	is_array(input.file)
	file := input.file[_]
	max_permissions(file, input.constants)
	f := dd.passed_finding(
		h.resource_type,
		h.resource_id,
		h.file_data(file),
	)
}

findings[f] {
	is_array(input.file)
	file := input.file[_]
	not max_permissions(file, input.constants)
	f := dd.failing_finding(
		h.resource_type,
		h.resource_id,
		h.file_data(file),
	)
}

findings[f] {
	not is_array(input.file)
	max_permissions(input.file, input.constants)
	f := dd.passed_finding(
		h.resource_type,
		h.resource_id,
		h.file_data(input.file),
	)
}

findings[f] {
	not is_array(input.file)
	not max_permissions(input.file, input.constants)
	f := dd.failing_finding(
		h.resource_type,
		h.resource_id,
		h.file_data(input.file),
	)
}

findings[f] {
	input.file == null
	f := dd.error_finding(
		h.resource_type,
		h.resource_id,
		sprintf("no files found for file check \"%s\"", [input.context.input.file.file.path]),
	)
}

findings[f] {
	count(input.file) == 0
	f := dd.error_finding(
		h.resource_type,
		h.resource_id,
		sprintf("no files found for file check \"%s\"", [input.context.input.file.file.path]),
	)
}

findings[f] {
	not h.has_key(input, "file")
	f := dd.error_finding(
		h.resource_type,
		h.resource_id,
		sprintf("failed to resolve path: empty path from %s", [input.context.input.file.file.path]),
	)
}
