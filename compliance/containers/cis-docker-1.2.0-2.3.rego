package datadog
import data.datadog as dd
import data.helpers as h

has_key(x, key) {
  _ := x[key]
}

compliant_config(file){
  file.content["iptables"] == false
}

compliant_process(process) {
  process.flags["--iptables"] == "false"
}

# default value is true
# https://docs.docker.com/engine/reference/commandline/dockerd/
noncompliant_process(process) {
  has_key(process.flags, "--iptables")
  process.flags["--iptables"] != "false"
}

compliant(in) {
  compliant_process(in.process)
} {
  not noncompliant_process(in.process)
  compliant_config(in.file)
}


# cli args take precedence
findings[f] {
  compliant(input)
  f := dd.passed_finding(
    h.resource_type,
    h.resource_id,
    {}
  )
} {
  not compliant(input)
  f := dd.failing_finding(
    h.resource_type,
    h.resource_id,
    {}
  )
} {
  # if dockerd process doesn't exist then error
  not has_key(input, "process")
  f := dd.error_finding(
     h.resource_type,
     h.resource_id,
     "process resource does not exist"
  )
}
