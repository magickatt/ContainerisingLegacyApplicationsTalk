path "database/creds/mybb" {
  capabilities = [ "read" ]
}

path "/sys/leases/renew" {
  capabilities = [ "update" ]
}
