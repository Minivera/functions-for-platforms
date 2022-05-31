#!/bin/sh

export FISSION_ROUTER=$(minikube ip):$(kubectl -n fission get svc router -o jsonpath='{...nodePort}')

fileid=$(curl -XPOST "http://$FISSION_ROUTER/upload" -H "Content-Type: text/plain" -d 'console.log("Hello, World!")' | sed 's/.*"id":\([^}]*\).*/\1/')

curl -XPOST -k -d "$fileid" "http://$FISSION_ROUTER/execute"
