# Deploying an interactive Busybox container

The approach is based on [OpenShift Examples: Deployments])(https://examples.openshift.pub/deploy/#simple-deployment)

## BusyBox

* [Wikipedia Busybox](https://en.wikipedia.org/wiki/BusyBox)
* [BusyBox - The Swiss Army Knife of Embedded Linux](https://busybox.net/downloads/BusyBox.html)
* [BusyBox-Commands](https://boxmatrix.info/wiki/BusyBox-Commands)


## Typical Usage

### OpenShift Local

> [Red Hat OpenShift Local](https://developers.redhat.com/products/openshift-local/overview) has an extra 
> level security [SCC Constraints](#scc-constraints) compared to [minikube](https://minikube.sigs.k8s.io/docs/).

```bash
kubeadmin$ oc adm policy add-scc-to-group anyuid system:authenticated --namespace="<project>"
developer$ oc apply -f busybox-deployment.yaml
developer$ oc get pods

developer$ oc exec --stdin --tty pod/<pod-name> -- sh
/ # ls 
bin   dev   etc   home  proc  root  run   sys   tmp   usr   var
/ # echo "hello world"
hello world
/ # exit
developer$

developer$ oc delete deployment.apps/busybox-deployment
kubeadmin$ oc adm policy remove-scc-from-group anyuid system:authenticated --namespace="<project>"
```

### Minikube

```bash
$ kubectl apply -f busybox-deployment.yaml
$ kubectl get pods

$ kubectl exec --stdin --tty pod/<pod-name> -- sh
/ # ls 
bin   dev   etc   home  proc  root  run   sys   tmp   usr   var
/ # echo "hello world"
hello world
/ # exit
$

$ kubectl delete deployment.apps/busybox-deployment
```
