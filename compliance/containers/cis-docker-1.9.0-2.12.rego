package datadog

storage_options[o] {
	o := flag_values(["--storage-opt"])[_]
}

storage_options[o] {
	count(flag_values(["--storage-opt"])) == 0
	o := daemon_config["storage-opts"][_]
}

daemon_compliant {
	count([o | o := storage_options[_]; startswith(o, "dm.basesize")]) == 0
}
