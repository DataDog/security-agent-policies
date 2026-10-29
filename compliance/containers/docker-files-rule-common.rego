package datadog

import data.datadog as dd
import data.helpers as h

# A file rule reads inputs tagged fileN, each a file or, for a glob, a list
# of files, and the files it finds must all comply: owned by the user and
# group of the constants, or with no permission beyond max_permissions. A
# rule that defines file_selection judges only the file at that path, and
# file_skip_reason says why a rule finds no file.

default file_selection = "*"

default file_skip_reason = "no file found"

input_files[f] {
	some k
	startswith(k, "file")
	f := input[k]
	is_object(f)
}

input_files[f] {
	some k
	startswith(k, "file")
	is_array(input[k])
	f := input[k][_]
}

found_files[f] {
	f := input_files[_]
	file_selection == "*"
}

found_files[f] {
	f := input_files[_]
	f.path == file_selection
}

# A file that two inputs find, such as a flag's file that a glob also
# matches, appears once.
files_data(files) = sort({h.file_data(x) | x := files[_]})

compliant_file(f) {
	f.user == input.constants.user
	f.group == input.constants.group
}

compliant_file(f) {
	f.permissions == bits.and(f.permissions, parse_octal(input.constants.max_permissions))
}

noncompliant_files[f] {
	f := found_files[_]
	not compliant_file(f)
}

findings[f] {
	count(found_files) > 0
	count(noncompliant_files) == 0
	f := dd.passed_finding(
		h.resource_type,
		h.resource_id,
		{"files": files_data(found_files)},
	)
}

findings[f] {
	count(noncompliant_files) > 0
	f := dd.failing_finding(
		h.resource_type,
		h.resource_id,
		{"files": files_data(noncompliant_files)},
	)
}

findings[f] {
	count(found_files) == 0
	f := dd.skipped_finding(
		h.resource_type,
		h.resource_id,
		file_skip_reason,
	)
}
