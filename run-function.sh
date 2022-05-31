#!/bin/sh

export FISSION_ROUTER=$(minikube ip):$(kubectl -n fission get svc router -o jsonpath='{...nodePort}')

curl -XPOST -d '{ "content": "console.log(\"Hello, World!\")" }' "http://$FISSION_ROUTER/upload"
curl -XPOST -k -d 'console.log("Hello, World!")' "http://$FISSION_ROUTER/run-isolated"
