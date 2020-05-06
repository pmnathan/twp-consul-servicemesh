node_prefix "" {
    policy = "write"
}

key_prefix "web" { 
    policy = "write" 
}

key_prefix "api" { 
    policy = "write" 
}

key_prefix "database" { 
    policy = "write" 
}

service_prefix "" {
policy = "read"
}

service_prefix "web" {
    policy = "write"
    intentions = "write"
}

service_prefix "web-proxy" {
policy = "write"
}

service_prefix "database" {
    policy = "write"
    intentions = "write"
}

service_prefix "database-proxy" {
    policy = "write"
}

service_prefix "api" {
    policy = "write"
    intentions = "write"
}

service_prefix "api-proxy" {
    policy = "write"
}

operator_prefix "" {
    policy = "write"
}
