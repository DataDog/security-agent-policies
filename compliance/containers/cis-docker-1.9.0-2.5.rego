package datadog

# Docker always lists the loopback networks as insecure registries.
loopback = {"127.0.0.0/8", "::1/128"}

insecure(i) {
	i.inspect.RegistryConfig.IndexConfigs[_].Secure == false
}

insecure(i) {
	cidr := i.inspect.RegistryConfig.InsecureRegistryCIDRs[_]
	not loopback[cidr]
}

valid_info(i) {
	not insecure(i)
}
