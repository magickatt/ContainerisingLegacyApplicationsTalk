#!/bin/bash

# Create a policy file, mybb-kv-readonly.hcl
# This assumes that the Vault server is running kv v1 (non-versioned kv)
tee mybb-kv-readonly.hcl <<EOF
# For K/V v1 secrets engine
path "secret/mybb/*" {
    capabilities = ["read", "list"]
}

# For K/V v2 secrets engine
path "secret/data/mybb/*" {
    capabilities = ["read", "list"]
}
EOF

# Create a policy named mybb-kv-readonly
vault policy write mybb-kv-readonly mybb-kv-readonly.hcl


# Create test data in the `secret/mybb` path.
# vault kv put secret/mybb/config username='appuser' password='suP3rsec(et!' ttl='30s'

# Enable userpass auth method
vault auth enable userpass

# Create a user named "test-user"
vault write auth/userpass/users/test-user password=training policies=mybb-kv-readonly

# Set VAULT_SA_NAME to the service account you created earlier
export VAULT_SA_NAME=$(kubectl get sa vault-auth -o jsonpath="{.secrets[*]['name']}")

# Set SA_JWT_TOKEN value to the service account JWT used to access the TokenReview API
export SA_JWT_TOKEN=$(kubectl get secret $VAULT_SA_NAME -o jsonpath="{.data.token}" | base64 --decode; echo)

# Set SA_CA_CRT to the PEM encoded CA cert used to talk to Kubernetes API
export SA_CA_CRT=$(kubectl get secret $VAULT_SA_NAME -o jsonpath="{.data['ca\.crt']}" | base64 --decode; echo)

# Set K8S_HOST to minikube IP address
export K8S_HOST=$(minikube ip)
export K8S_HOST=$(kubectl exec singed-flee-consul-server-0 -- sh -c 'echo $KUBERNETES_SERVICE_HOST')

# Enable the Kubernetes auth method at the default path ("auth/kubernetes")
vault auth enable kubernetes

# Tell Vault how to communicate with the Kubernetes (Minikube) cluster
vault write auth/kubernetes/config token_reviewer_jwt="$SA_JWT_TOKEN" kubernetes_host="https://$K8S_HOST:8443" kubernetes_ca_cert="$SA_CA_CRT"

# Create a role named, 'example' to map Kubernetes Service Account to
#  Vault policies and default token TTL
vault write auth/kubernetes/role/mybb bound_service_account_names=vault-auth bound_service_account_namespaces=default policies=mybb-kv-readonly ttl=24h
