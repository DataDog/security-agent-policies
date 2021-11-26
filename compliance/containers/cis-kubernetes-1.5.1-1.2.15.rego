package datadog

import data.helpers as h

valid_process(process) {
	not h.has_key(process.flags, "--disable-admission-plugins")
}

valid_process(process) {
	not regex.match("NamespaceLifecycle", process.flags["--disable-admission-plugins"])
}
