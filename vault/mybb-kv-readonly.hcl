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
