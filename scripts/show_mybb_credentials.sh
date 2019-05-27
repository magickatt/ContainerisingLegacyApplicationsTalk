export MYBB_POD=$(kubectl get pods --namespace default -l "app=mybb" -o jsonpath="{.items[0].metadata.name}")

echo "kubectl exec $MYBB_POD -c mybb -- cat /var/www/mybb/inc/config.php | grep -B 1 password"
kubectl exec $MYBB_POD -c mybb -- cat /var/www/mybb/inc/config.php | grep -B 1 password
