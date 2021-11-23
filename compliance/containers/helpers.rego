package helpers

import data.datadog as dd

has_key(o, k) {
	_ := o[k]
}

resource_type = rt {
	not input.constants.resource_type == "docker_info"
	rt := input.constants.resource_type
}

resource_type = rt {
	input.constants.resource_type == "docker_info"
	rt := "docker_daemon"
}

resource_id = rid {
	input.constants.resource_type == "docker_daemon"
	rid := dd.docker_daemon_resource_id
}

resource_id = rid {
	input.constants.resource_type == "kubernetes_worker_node"
	rid := dd.kubernetes_worker_node_resource_id
}

resource_id = rid {
	input.constants.resource_type == "kubernetes_cluster"
	rid := dd.kubernetes_cluster_resource_id
}

resource_id = rid {
	input.constants.resource_type == "kubernetes_master_node"
	rid := dd.kubernetes_master_node_resource_id
}

resource_id = rid {
	input.constants.resource_type == "docker_info"
	rid := dd.docker_daemon_resource_id
}

resource_id = rid {
	input.constants.resource_type == "docker_container"
	rid := dd.docker_daemon_resource_id
}
