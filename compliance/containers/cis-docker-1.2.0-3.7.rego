package datadog
import data.datadog as dd
import data.helpers as h

has_key(o, k) {
  _ := o[k]
}

compliant(files) {
  c := input.constants
  count([f | f := files[_]; f.user == c.user; f.group == c.group]) == count(files)
}

findings[f] {
  compliant(input.files)
  f := dd.passed_finding(
    h.resource_type,
    h.resource_id,
    {"files": [dd.file_data(f) | f := input.files[_]]}
  )
} {
  not compliant(input.files)
  f := dd.failing_finding(
    h.resource_type,
    h.resource_id,
    {"files": [dd.file_data(f) | f := input.files[_]]}
  )
} {
  count(input.files) == 0
  f := dd.error_finding(
    h.resource_type,
    h.resource_id,
    sprintf("no files found for file check \"%s\"", [input.context.input.file.file.path])
  )
} {
  not has_key(input, "files")
  f := dd.error_finding(
     h.resource_type,
     h.resource_id,
     sprintf("no files found for file check \"%s\"", [input.context.input.file.file.path])
   )
}
