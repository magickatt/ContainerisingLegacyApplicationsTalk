#!/bin/bash

MYSQL_POD=$(kubectl get pods --namespace default -l "app=database-mysql" -o jsonpath="{.items[0].metadata.name}")
kubectl port-forward $MYSQL_POD 3306:3306 &
