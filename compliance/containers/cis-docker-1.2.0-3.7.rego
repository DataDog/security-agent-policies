package datadog

import data.datadog as dd
import data.helpers as h
import future.keywords.every

compliant(files) {
	c := input.constants

	every f in files {
		f.user == c.user
		f.group == c.group
	}
}

findings[f] {
	compliant(input.files)
	f := dd.passed_finding(
		h.resource_type,
		h.resource_id,
		{"files": [h.file_data(f) | f := input.files[_]]},
	)
}

findings[f] {
	not compliant(input.files)
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
		sprintf("no files found for file check \"%s\"", [input.context.input.file.file.path]),
	)
}

findings[f] {
	not h.has_key(input, "files")
	f := dd.error_finding(
		h.resource_type,
		h.resource_id,
		sprintf("no files found for file check \"%s\"", [input.context.input.file.file.path]),
	)
}
