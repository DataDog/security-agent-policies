package datadog

valid_info(i) {
	i.inspect.RegistryConfig.InsecureRegistryCIDRs == null
}

valid_info(i) {
	count(i.inspect.RegistryConfig.InsecureRegistryCIDRs) == 0
}
