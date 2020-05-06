datacenter          = "consuldemo"
server              = true
bootstrap_expect    = 1
data_dir            = "/etc/consul.d"
advertise_addr      = "172.20.20.10"
client_addr         = "0.0.0.0"
log_level           = "DEBUG"
ui                  = true

performance {
    raft_multiplier = 1
}

ports {
  grpc = 8502
}

connect {
  enabled = true
}

enable_central_service_config = true

#acl = {
#  enabled = true
#  default_policy = "allow"
#  enable_token_persistence = true
#}
