# For K/V v1 secrets engine
path "secret/mybb/*" {
    capabilities = ["read", "list"]
}

# For K/V v2 secrets engine
path "secret/data/mybb/*" {
    capabilities = ["read", "list"]
}

path "secret/*" {
    capabilities = ["list"]
}

path "database/creds/mybb" {
  capabilities = [ "read" ]
}

path "/sys/leases/renew" {
  capabilities = [ "update" ]
}

path "secret/data/test" {
  capabilities = ["read"]
}
