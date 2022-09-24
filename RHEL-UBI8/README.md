# Deploying an interactive RHEL-UBI container

The approach is based on [OpenShift Examples: Deployments])(https://examples.openshift.pub/deploy/#simple-deployment)

## BusyBox

* [Introducing the Red Hat Universal Base Image](https://www.redhat.com/en/blog/introducing-red-hat-universal-base-image)
* [Red Hat Universal Base Image 8](https://catalog.redhat.com/software/container-stacks/detail/5ec53f50ef29fd35586d9a56)
* [DockerHub: redhat/ubi8](https://hub.docker.com/r/redhat/ubi8)

## Typical Usage

The `oc adm policy` commands are need on `OpenShift Kubernetes Environment`` such as [Red Hat OpenShift Local (formerly Red Hat CodeReady Containers)](https://developers.redhat.com/products/openshift-local/overview)
and can be omitted on other Kubernetes platforms.
The approach is based on [OpenShift Examples: Deployments])(https://examples.openshift.pub/deploy/#simple-deployment)

```bash
#
kubeadmin$ oc adm policy add-scc-to-group anyuid system:authenticated --namespace="<project>"
developer$ oc apply -f rhel-ubi8-deployment.yaml
developer$ oc exec --stdin --tty pod/<pod-name> -- bash

bash-4.4$ ls
bin  boot  dev	etc  home  lib	lib64  lost+found  media  mnt  opt  proc  root	run  sbin  srv	sys  tmp  usr  var
bash-4.4$ echo "hello world"
hello world
bash-4.4$ exit
developer$

developer$ oc delete deployment.apps/rhel-ubi8-deployment
kubeadmin$ oc adm policy remove-scc-from-group anyuid system:authenticated --namespace="<project>"
```