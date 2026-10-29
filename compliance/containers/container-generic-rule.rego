package datadog

import data.datadog as dd
import data.helpers as h

# A container rule defines valid_container, and skip_container for the
# containers its recommendation leaves out.

skip_container(c) {
	false
}

findings[f] {
	c := input.containers[_]
	not skip_container(c)
	valid_container(c)
	f := dd.passed_finding(
		h.resource_type,
		h.docker_container_resource_id(c),
		h.docker_container_data(c),
	)
}

findings[f] {
	c := input.containers[_]
	not skip_container(c)
	not valid_container(c)
	f := dd.failing_finding(
		h.resource_type,
		h.docker_container_resource_id(c),
		h.docker_container_data(c),
	)
}

findings[f] {
	c := input.containers[_]
	skip_container(c)
	f := dd.skipped_finding(
		h.resource_type,
		h.docker_container_resource_id(c),
		"the recommendation leaves this container out",
	)
}

container_running(c) {
	c.inspect.State.Running == true
}

# datadog_agent_image holds for a container that runs a Datadog Agent or
# Cluster Agent image, which mounts host paths by design.
datadog_agent_image(c) {
	image_repository(c.inspect.Config.Image) == datadog_agent_repositories[_]
}

datadog_agent_repositories = [
	"docker.io/datadog/agent",
	"docker.io/datadog/cluster-agent",
	"gcr.io/datadoghq/agent",
	"gcr.io/datadoghq/cluster-agent",
	"eu.gcr.io/datadoghq/agent",
	"eu.gcr.io/datadoghq/cluster-agent",
	"asia.gcr.io/datadoghq/agent",
	"asia.gcr.io/datadoghq/cluster-agent",
	"public.ecr.aws/datadog/agent",
	"public.ecr.aws/datadog/cluster-agent",
	"datadoghq.azurecr.io/agent",
	"datadoghq.azurecr.io/cluster-agent",
	"registry.datadoghq.com/agent",
	"registry.datadoghq.com/cluster-agent",
]

# image_repository returns the repository of an image reference with its
# registry and without tag or digest: datadog/agent:7 gives
# docker.io/datadog/agent.
image_repository(ref) = repo {
	name := split(lower(ref), "@")[0]
	parts := split(name, "/")
	n := count(parts)
	path := array.concat(array.slice(parts, 0, n - 1), [split(parts[n - 1], ":")[0]])
	repo := qualified_repository(path)
}

qualified_repository(path) = repo {
	count(path) == 1
	repo := concat("/", array.concat(["docker.io", "library"], path))
}

qualified_repository(path) = repo {
	count(path) > 1
	not registry_host(path[0])
	repo := concat("/", array.concat(["docker.io"], path))
}

qualified_repository(path) = repo {
	count(path) > 1
	registry_host(path[0])
	path[0] != "index.docker.io"
	repo := concat("/", path)
}

qualified_repository(path) = repo {
	count(path) > 1
	path[0] == "index.docker.io"
	repo := concat("/", array.concat(["docker.io"], array.slice(path, 1, count(path))))
}

registry_host(s) {
	contains(s, ".")
}

registry_host(s) {
	contains(s, ":")
}

registry_host(s) {
	s == "localhost"
}
