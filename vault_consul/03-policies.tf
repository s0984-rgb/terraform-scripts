resource "consul_acl_policy" "consul_server" {
  name        = "consul-server"
  datacenters = ["dc1"]
  rules       = <<-RULE
    agent_prefix "" {
    policy = "read"
    }
    node_prefix "consul" {
    policy = "write"
    }
    node_prefix "" {
    policy = "read"
    }
    service_prefix "" {
    policy = "read"
    }
    RULE
}

resource "consul_acl_policy" "consul_client" {
  name        = "consul-client"
  datacenters = ["dc1"]
  rules       = <<-RULE
    agent_prefix "" {
    policy = "read"
    }
    node_prefix "nomad-" {
    policy = "write"
    }
    node_prefix "" {
    policy = "read"
    }
    service_prefix "" {
    policy = "write"
    }
    RULE
}


resource "consul_acl_policy" "nomad_server" {
  name        = "nomad-server"
  datacenters = ["dc1"]
  rules       = <<-RULE
    agent_prefix "" {
      policy = "read"
    }

    node_prefix "" {
      policy = "read"
    }

    service_prefix "" {
      policy = "write"
    }
    RULE
}

resource "consul_acl_policy" "nomad_client" {
  name        = "nomad-client"
  datacenters = ["dc1"]
  rules       = <<-RULE
    agent_prefix "" {
      policy = "read"
    }

    node_prefix "" {
      policy = "read"
    }

    service_prefix "" {
      policy = "write"
    }
    RULE
}
