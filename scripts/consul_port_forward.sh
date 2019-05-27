export CONSUL_POD=configuration-consul-server-0
kubectl port-forward $CONSUL_POD 8500:8500 &
