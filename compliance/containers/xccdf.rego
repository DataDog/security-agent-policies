package datadog

import data.datadog as dd

passed_result(result) {
	result.result == "passed"
}

failing_result(result) {
	result.result == "failing"
}

findings[f] {
	xccdf_result := input.xccdf[_]
	passed_result(xccdf_result)
	f := dd.passed_finding(
		"host",
		xccdf_result.name,
		{},
	)
}

findings[f] {
	xccdf_result := input.xccdf[_]
	failing_result(xccdf_result)
	f := dd.failing_finding(
		"host",
		xccdf_result.name,
		{},
	)
}
