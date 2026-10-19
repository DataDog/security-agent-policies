package datadog

import data.datadog as dd
import data.helpers as h

healthcheck(img) {
	t := img.inspect.Config.Healthcheck.Test
	count(t) > 0
	t[0] != "NONE"
}

# The rule judges the images a container can name, by a tag or a
# repository digest. The classic builder keeps an image with neither for
# each build step.
named(img) {
	img.inspect.RepoTags[_]
}

named(img) {
	img.inspect.RepoDigests[_]
}

findings[f] {
	img := input.images[_]
	named(img)
	healthcheck(img)
	f := dd.passed_finding(
		h.resource_type,
		h.docker_image_resource_id(img),
		h.docker_image_data(img),
	)
}

findings[f] {
	img := input.images[_]
	named(img)
	not healthcheck(img)
	f := dd.failing_finding(
		h.resource_type,
		h.docker_image_resource_id(img),
		h.docker_image_data(img),
	)
}
