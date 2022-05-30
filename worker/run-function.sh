#!/bin/sh

export FISSION_ROUTER=$(minikube ip):31314

curl -XPOST -k -d 'console.log("Hello, World!")'  http://$FISSION_ROUTER/run-isolated
