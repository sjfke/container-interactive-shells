# Deploying an interactive Busybox container

The approach is based on [OpenShift Examples: Deployments])(https://examples.openshift.pub/deploy/#simple-deployment)

## BusyBox

* [Wikipedia Busybox](https://en.wikipedia.org/wiki/BusyBox)
* [BusyBox - The Swiss Army Knife of Embedded Linux](https://busybox.net/downloads/BusyBox.html)
* [BusyBox-Commands](https://boxmatrix.info/wiki/BusyBox-Commands)

## Typical Usage

The `oc adm policy` commands are need on `OpenShift Kubernetes Environment`` such as [Red Hat OpenShift Local (formerly Red Hat CodeReady Containers)](https://developers.redhat.com/products/openshift-local/overview)
and can be omitted on other Kubernetes platforms.

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
