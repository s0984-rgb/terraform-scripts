namespace "test" {
    capabilities = ["list-jobs", "parse-job", "read-job", "submit-job", "read-logs", "alloc-exec", "scale-job"]
}

node {
    policy = "read"
}

agent {
    policy = "deny"
}

operator {
    policy = "deny"
}

quota {
    policy = "deny"
}

host_volume "*" {
    policy = "write"
}

plugin {
    policy = "read"
}