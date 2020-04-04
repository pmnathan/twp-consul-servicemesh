datacenter          = "consuldemo"
server              = false
data_dir            = "/etc/consul.d"
advertise_addr      = "172.20.20.15"
client_addr         = "0.0.0.0"
log_level           = "INFO"
ui                  = false

retry_join = ["172.20.20.10"]

