package datadog

# A host without a scheme, such as 0.0.0.0:2375, is a TCP socket.
tcp_host(host) {
	startswith(host, "tcp://")
}

tcp_host(host) {
	not contains(host, "://")
	not startswith(host, "/")
}

hosts[host] {
	host := flag_values(["-H", "--host"])[_]
}

hosts[host] {
	count(flag_values(["-H", "--host"])) == 0
	host := daemon_config.hosts[_]
}

tcp_hosts[host] {
	host := hosts[_]
	tcp_host(host)
}

# With fd://, dockerd takes its sockets from systemd, which opens those
# that ListenStream sets in the docker.socket unit and its drop-ins.
tcp_hosts[addr] {
	startswith(hosts[_], "fd://")
	addr := socket_listeners[_]
	socket_tcp(addr)
}

# A ListenStream address other than a path, an abstract socket or a
# vsock address is a TCP socket.
socket_tcp(addr) {
	not startswith(addr, "/")
	not startswith(addr, "%")
	not startswith(addr, "@")
	not startswith(addr, "vsock:")
}

# systemd takes the unit from the first directory of its search path
# that holds one: /etc, /run, /usr/local/lib, /usr/lib, then /lib.
socket_unit = f {
	f := input.socket_etc
}

socket_unit = f {
	not input.socket_etc
	f := input.socket_run
}

socket_unit = f {
	not input.socket_etc
	not input.socket_run
	f := input.socket_local
}

socket_unit = f {
	not input.socket_etc
	not input.socket_run
	not input.socket_local
	f := input.socket_usr
}

socket_unit = f {
	not input.socket_etc
	not input.socket_run
	not input.socket_local
	not input.socket_usr
	f := input.socket_lib
}

dropin_name(f) = name {
	parts := split(f.path, "/")
	name := parts[count(parts) - 1]
}

# Drop-ins apply in the order of their names, and one replaces those of
# the same name further down the search path.
dropins[name] = f {
	f := input.socket_dropins_etc[_]
	name := dropin_name(f)
}

dropins[name] = f {
	f := input.socket_dropins_run[_]
	name := dropin_name(f)
	not etc_dropin(name)
}

dropins[name] = f {
	f := input.socket_dropins_local[_]
	name := dropin_name(f)
	not etc_dropin(name)
	not run_dropin(name)
}

dropins[name] = f {
	f := input.socket_dropins_usr[_]
	name := dropin_name(f)
	not etc_dropin(name)
	not run_dropin(name)
	not local_dropin(name)
}

etc_dropin(name) {
	dropin_name(input.socket_dropins_etc[_]) == name
}

run_dropin(name) {
	dropin_name(input.socket_dropins_run[_]) == name
}

local_dropin(name) {
	dropin_name(input.socket_dropins_local[_]) == name
}

socket_files = array.concat([f | f := socket_unit], [dropins[name] | name := sort([n | dropins[n]])[_]])

listen_value(line) = v {
	l := trim_space(line)
	i := indexof(l, "=")
	i > 0
	trim_space(substring(l, 0, i)) == "ListenStream"
	v := trim_space(substring(l, i + 1, -1))
}

listen_values = [v | f := socket_files[_]; line := split(f.content, "\n")[_]; v := listen_value(line)]

# An empty ListenStream resets the list.
last_reset = r {
	resets := [i | listen_values[i] == ""]
	count(resets) > 0
	r := max(resets)
}

last_reset = -1 {
	count([i | listen_values[i] == ""]) == 0
}

socket_listeners[addr] {
	addr := listen_values[i]
	addr != ""
	i > last_reset
}

daemon_skip_reason = "the daemon listens on no TCP socket" {
	count(tcp_hosts) == 0
}

tls_file(names, key) {
	daemon_setting(names, key) != ""
}

daemon_compliant {
	is_true(daemon_setting(["--tlsverify"], "tlsverify"))
	tls_file(["--tlscacert"], "tlscacert")
	tls_file(["--tlscert"], "tlscert")
	tls_file(["--tlskey"], "tlskey")
}

daemon_data = {"daemon.tcp_hosts": sort(tcp_hosts)}
