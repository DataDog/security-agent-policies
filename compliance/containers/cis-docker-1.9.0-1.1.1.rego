package datadog

import data.datadog as dd
import data.helpers as h

# With user namespace remapping, the daemon keeps its data in a
# subdirectory of the data root named after the remapped user and group,
# such as /var/lib/docker/100000.100000.
remapped(i) {
	startswith(i.inspect.SecurityOptions[_], "name=userns")
	regex.match(`/[0-9]+\.[0-9]+$`, i.inspect.DockerRootDir)
}

data_root = root {
	i := input.infos[0]
	not remapped(i)
	root := i.inspect.DockerRootDir
}

data_root = root {
	i := input.infos[0]
	remapped(i)
	parts := split(i.inspect.DockerRootDir, "/")
	root := concat("/", array.slice(parts, 0, count(parts) - 1))
}

# The mount points of /proc/1/mounts escape a space as \040.
root_dir = replace(data_root, " ", "\\040")

mount_point(line) = p {
	p := split(line, " ")[1]
}

separate {
	lines := split(input.mounts.content, "\n")
	mount_point(lines[_]) == root_dir
}

findings[f] {
	separate
	f := dd.passed_finding(
		h.resource_type,
		h.resource_id,
		{"docker.root_dir": data_root},
	)
}

findings[f] {
	input.mounts.content
	not separate
	f := dd.failing_finding(
		h.resource_type,
		h.resource_id,
		{"docker.root_dir": data_root},
	)
}

findings[f] {
	not h.has_key(input, "mounts")
	f := dd.skipped_finding(
		h.resource_type,
		h.resource_id,
		"/proc/1/mounts is missing",
	)
}
