# Functions for platforms
This is an implementation of the recently announced [workers-for-platforms](https://blog.cloudflare.com/workers-for-platforms)
from Cloudflare. It uses the fission.io framework to generate a v8 environment where we can run multiple functions 
in an isolated and controlled environment. This is just a proof of concept and has some major security issues, but 
it shows how we can leverage the ideas from the Cloudflare blog post to execute arbitrary user code.

## How to set up the functions
This example is built with the fission framework and kubernetes. Follow these steps to get the example going.

1. Install [docker](https://docs.docker.com/get-docker/), based on your OS.
2. Install [kubectl](https://kubernetes.io/docs/tasks/tools/) and [helm](https://helm.sh/docs/intro/install/) to be 
   able to manipulate a kubernetes cluster.
3. Install the [fission CLI](https://fission.io/docs/installation/#install-fission-cli).
4. Install [minikube](https://minikube.sigs.k8s.io/docs/start/), a tool that uses docker to run a local kubernetes cluster.
5. Start your minikube cluster (`minikube start`), this will download and set up the kubernetes cluster on your 
   machine. If you wish to stop the API at any time, use `minikube stop`.
6. Switch to the minikube env for docker (`eval $(minikube -p minikube docker-env)`), this will tell docker to use 
   the minikube environment as the target for pushing and pulling images. 
7. Install fission using the minikube commands, the command can be found in the official documentation. https://fission.io/docs/installation/
8. Apply the persistent volume configuration from the kubernetes directory (`kubectl apply -f ./kubernetes/code-volume.yaml`), 
   this volume will contain all the JavaScript files uploaded by users. This is a small test disk, a real implementation 
   would likely use a network disk of some kind.
9. `cd` into the `image` directory and run the build command (`./build.sh`) to build the v8 environment. This is an 
   extended version of fission's binary environment with the v8 binaries installed. `cd` back into the root once you're done.
10. Build the javascript archives (`npm run build`), these archives contain the JavaScript code for uploading script to the persistent disk. 
    We use archives to allow installing dependencies in case we need to access the `node_modules`.
11. Apply the fission spec files to the cluster (`npm run apply`), this will set up the infrastructure for our 
    environments, functions, triggers, and other configurations for fission. If you need to update any specs files 
    after changing them, run `npm run apply` again, or use `npm run apply:watch` to watch the file and apply the 
    changes when the files are saved.
12. (Optional) if using MacOS or Windows, you may need a load balancer. Create the load balancer
    (`kubectl apply -f ./kubernetes/load-balancer.yaml`) then start the minikube tunnel in a separate terminal 
    (`minikube tunnel`). The load balancer will give an external IP to the router service on kubernetes, which is 
    needed when using Docker for Desktop.

> _Note that this example may not work on M1 Mac, as the v8 binary is not compiled for arm64 architectures._

## Execute the function
Once the architecture is set up, you can start using the API. Either run the test file `./run_function.sh` or send 
call to the API using the following method:

1. Get the API URl by asking `minikube` for its IP and `kubectl` for the service/load balancer port.
2. Send a code file through the program of your choice by sending an HTTP request the `/upload` endpoint on the API with your JavaScript 
code as the plain text body. For example, to make a `curl` call, use `FISSION_ROUTER=$(minikube ip):$(kubectl -n fission get svc router -o jsonpath='{...nodePort}') curl -XPOST "http://$FISSION_ROUTER/upload" -H "Content-Type: text/plain" -d 'console.log("Hello, World!")'`
3. This call will return an ID if it worked as expected, make a call to the `/execute` endpoint with the ID given by the previous call as the raw text body. The endpoint should return the path to the file and the result of the execution of the JavaScript file in a safe and isolated v8 environment. For example, to make a `curl` call, use `FISSION_ROUTER=$(minikube ip):$(kubectl -n fission get svc router -o jsonpath='{...nodePort}') curl -XPOST "http://$FISSION_ROUTER/execute" -H "Content-Type: text/plain" -d '<ID>'`, replacing `<ID>` with the id from the previous call.

## See the logs of the function
In case you run into issues or need to update the code itself and see if your changes are working, you can see the 
logs of the environment executions (Where the actual functions are run) using the following command. Any console log 
or print statement will appear in these logs. Each log may be printed around 3 times as the function are balanced 
between multiple kubernetes pods.

```bash
# Replace v8 with nodejs to see the nodejs environment logs
kubectl logs -l environmentName=v8 -n fission-function 
```

## Helpful links
- https://gist.github.com/sanketsudake/cd9dc79296f2a8099d10342842d4f649
- https://medium.com/swlh/how-to-run-locally-built-docker-images-in-kubernetes-b28fbc32cc1d
