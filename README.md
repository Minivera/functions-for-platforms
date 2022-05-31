# Functions for platforms

## Steps:

1. Install docker
2. Install kubectl and helm
3. Install the fission CLI
4. Start your minikube cluster (`minikube start`)
5. Switch to the minikube env for docker (`eval $(minikube -p minikube docker-env)`)
6. Install fission using the minikube commands
7. Apply the persistent volume configuration from the kubernetes directory (`kubectl apply -f .
   /kubernetes/code-volume.yaml`)
8. cd into the image directory and run the build command (`./build.sh`)
9. Build the javascrit archives (`npm run build`)
10. Apply the fission spec files to the cluster (`npm run apply`)
11. (Optional) if using MacOS or Windows, you may need a load balancer. Create the load balancer (`kubectl apply -f .
    /kubernetes/load-balancer.yaml`) then start the minikube tunnel in a separate terminal (`minikube tunnel`).