package datadog

# The daemon rules read the dockerd process, tagged process, and its
# configuration file: the one that --config-file names, tagged
# daemon_json_flag, else /etc/docker/daemon.json, tagged daemon_json. A
# setting comes from its last flag on the command line, else from the
# configuration file, else from the default of dockerd, which refuses a
# setting given in both places.

boolean_flags = {
	"-D", "--debug",
	"--iptables",
	"--live-restore",
	"--no-new-privileges",
	"--tlsverify",
	"--userland-proxy",
}

dockerd = input.process[0]

flag_value(cmd, i, names) = v {
	name := names[_]
	startswith(cmd[i], concat("", [name, "="]))
	v := substring(cmd[i], count(name) + 1, -1)
}

flag_value(cmd, i, names) = v {
	cmd[i] == names[_]
	not boolean_flags[cmd[i]]
	v := cmd[i + 1]
}

flag_value(cmd, i, names) = "true" {
	cmd[i] == names[_]
	boolean_flags[cmd[i]]
}

# A short flag also takes its value attached, as in -Htcp://0.0.0.0:2375.
flag_value(cmd, i, names) = v {
	name := names[_]
	count(name) == 2
	not boolean_flags[name]
	startswith(cmd[i], name)
	count(cmd[i]) > 2
	not startswith(cmd[i], concat("", [name, "="]))
	v := substring(cmd[i], 2, -1)
}

# flag_values returns every value that the dockerd command line gives the
# flag spelled as one of names.
flag_values(names) = values {
	cmd := dockerd.cmdLine
	values := [v | cmd[i]; v := flag_value(cmd, i, names)]
}

daemon_setting(names, key) = v {
	values := flag_values(names)
	count(values) > 0
	v := values[count(values) - 1]
}

daemon_setting(names, key) = v {
	count(flag_values(names)) == 0
	v := daemon_config[key]
}

config_file_flag {
	count(flag_values(["--config-file"])) > 0
}

daemon_config = c {
	config_file_flag
	c := input.daemon_json_flag.content
}

daemon_config = c {
	not config_file_flag
	c := input.daemon_json.content
}

# dockerd parses boolean flags with strconv.ParseBool.
is_true(v) {
	v == true
}

is_true(v) {
	{"1", "t", "T", "TRUE", "true", "True"}[v]
}

is_false(v) {
	v == false
}

is_false(v) {
	{"0", "f", "F", "FALSE", "false", "False"}[v]
}
