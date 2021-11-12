package datadog

import data.datadog as dd

findings[f] {
  image := input.images[_]
  valid_image[image]
  f := dd.passed_finding(
    "docker_image",
    dd.docker_image_resource_id(image),
    dd.docker_image_data(image)
  )
}

findings[f] {
  image := input.images[_]
  not valid_image[image]
  f := dd.failing_finding(
    "docker_image",
    dd.docker_image_resource_id(image),
    dd.docker_image_data(image)
  )
}

valid_image[image] {
  image := input.images[_]
  image.inspect.Config.Healthcheck.Test != ""
}
