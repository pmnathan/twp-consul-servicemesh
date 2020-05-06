datacenter          = "consuldemo"
server              = false
data_dir            = "/etc/consul.d"
advertise_addr      = "172.20.20.11"
client_addr         = "0.0.0.0"
log_level           = "INFO"
ui                  = false
leave_on_terminate  = false
skip_leave_on_interrupt = true
rejoin_after_leave  =  true

ports {
  grpc = 8502
}

connect {
  enabled = true
}

retry_join = ["172.20.20.10"]

enable_central_service_config = true

#acl = {
#  enabled = true
#  default_policy = "allow"
#  enable_token_persistence = true
#}
