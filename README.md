# Containers which provide an Interactive Shell

The following containers can be deployed in a `kubernetes` cluster for troubleshooting and debugging.

* [Simple RHEL UBI-8 deployment](#rhel-ubi-deployments)
* [Simple BusyBox deployment](#busybox-deployment)
* [SomaCLI container with Non-Root Bash Shell, plus `sudo`](#somacli)

These containers are tested on:

* Fedora Linux 37 using [Red Hat OpenShift Local](https://developers.redhat.com/products/openshift-local/overview)
* MacOS using [minikube](https://minikube.sigs.k8s.io/docs/) (*brew install*) which requires [Docker Desktop](https://docs.docker.com/desktop/)

In each case a `<prefix>-deployment.yaml` file is provided which can be applied using:
* OpenShift `oc apply -f <prefix>-deployment.yaml`, see [SCC Constraints](#scc-constraints) 
* Minikube/Kubernetes `kubectl apply -f <prefix>-deployment.yaml`

> [Red Hat OpenShift](https://developers.redhat.com/products/openshift-local/overview) has an extra 
> security level constraints, see [SCC Constraints](#scc-constraints), compared to [minikube](https://minikube.sigs.k8s.io/docs/).

## RHEL UBI deployments

* [Introducing the Red Hat Universal Base Image](https://www.redhat.com/en/blog/introducing-red-hat-universal-base-image)
* [Red Hat Universal Base Image 8](https://catalog.redhat.com/software/container-stacks/detail/5ec53f50ef29fd35586d9a56)
* [Red Hat Universal Base Image 9](https://catalog.redhat.com/software/container-stacks/detail/609560d9e2b160d361d24f98)
* [DockerHub: redhat/ubi8](https://hub.docker.com/r/redhat/ubi8)
* [DockerHub: redhat/ubi9](https://hub.docker.com/r/redhat/ubi9)
* [README](RHEL-UBI/README.md)
* [rhel-ubi8-deployment.yaml](RHEL-UBI/rhel-ubi8-deployment.yaml)
* [rhel-ubi9-deployment.yaml](RHEL-UBI/rhel-ubi9-deployment.yaml)


## BusyBox deployment

* [Wikipedia Busybox](https://en.wikipedia.org/wiki/BusyBox)
* [BusyBox - The Swiss Army Knife of Embedded Linux](https://busybox.net/downloads/BusyBox.html)
* [BusyBox-Commands](https://boxmatrix.info/wiki/BusyBox-Commands)
* [README](./BusyBox/README.md)
* [busybox-deployment.yaml](./BusyBox/busybox-deployment.yaml)


## SomaCLI

Provides a non-root Bash Shell based on RHEL UBI-8 with the following additional packages:

* *nmap-ncat*, *bind-utils*, *iputils*, *ip* packages and a preconfigured *sudo*

### Interactive Bash Shell

The RHEL UBI-8 image includes:
* [sudoers](https://en.wikipedia.org/wiki/Sudo): with: 'soma ALL=(ALL) NOPASSWD:ALL'
* [nmap-ncat](https://nmap.org/ncat/guide/index.html): nc, ncat
* [bind-utils](https://www.mankier.com/package/bind-utils): nslookup, dig, host, nsupdate, arpaname
* [iputils](https://www.mankier.com/package/iputils): ping, tracepath; /usr/sbin/: arping, ping[6], tracepath[6]
* [ip](https://www.mankier.com/package/ip): link, address, route, rule, neigh, maddress, monitor etc.

### Websites

* [GitHub: RHEL-8 Universal Base Image Docker Containers](https://github.com/sjfke/rhel-ubi8-containers)
* [Docker.io: sjfke/rhel-ubi8-soma](https://hub.docker.com/repository/docker/sjfke/rhel-ubi8-soma)
* [Quay.io: quay.io/sjfke/rhel-ubi8-soma](https://hub.docker.com/repository/docker/sjfke/rhel-ubi8-soma)

### Files

* [soma-cli-deployment.yaml](./SomaCLI/soma-cli-deployment.yaml)
* [Dockerfile](./SomaCLI/Dockerfile): Docker configuration file.
* [BUILDME](./SomaCLI/BUILDME.md): Image build, deployment and test.

The following are generated using: `create-unix-files.sh` to avoid `CR/LF` issues when building on non-Linux systems.

* ***bashrc:*** /home/soma/.bashrc
* ***bash_profile:*** /home/soma/.bash_profile
* ***motd:*** /etc/motd, /etc/issue.net
* ***soma:*** /etc/sudoers.d/soma

### Usage

#### One-off invocation

```bash
# Openshift Container Platform - add all authenticated users to SCC group policy 'anyuid' 
kubeadmin$ oc adm policy add-scc-to-group anyuid system:authenticated --namespace="<project>"

developer$ oc debug --tty --image docker.io/sjfke/rhel-ubi8-soma:latest # -or- 
developer$ oc run soma-pod --rm -i --tty --image docker.io/sjfke/rhel-ubi8-soma:latest
If you don't see a command prompt, try pressing enter.
[soma@soma-pod ~]$ cat /etc/motd
##############################################################################
#         WARNING: Unauthorized access to this system is forbidden!          #
#                All connections are monitored and recorded.                 #
#         Disconnect IMMEDIATELY if you are not an authorized user!          #
#                                                                            #
# -------------------------------------------------------------------------- #
# Idea stolen from: Brave New World by Aldous Huxley                         #
# SOMA: numbs any sort of discomfort, anxiety, stress and general uneasiness #
# -------------------------------------------------------------------------- #
# sudoers: soma ALL=(ALL) NOPASSWD:ALL                                       #
# nmap-ncat: nc, ncat                                                        #
# bind-utils: nslookup, dig, host, nsupdate, arpaname                        #
# iputils: ping, tracepath; /usr/sbin/: arping, ping[6], tracepath[6]        #
# ip: link, address, route, rule, neigh, maddress, monitor etc.              #
##############################################################################

[soma@soma-pod ~]$ sudo -l
User soma may run the following commands on <pod-name>:
  (ALL) ALL
  (ALL) NOPASSWD: ALL

[soma@soma-pod ~]$ exit
logout
Session ended, resume using 'oc attach soma-pod -c soma-pod -i -t' command when the pod is running
pod "soma-pod" deleted

# Openshift Container Platform - remove all authenticated users from SCC group policy 'anyuid'
kubeadmin$ oc adm policy remove-scc-from-group anyuid system:authenticated --namespace="<project>"
```
```bash
$ kubectl debug --tty --image docker.io/sjfke/rhel-ubi8-soma:latest # -or- 
$ kubectl run soma-pod --rm -i --tty --image docker.io/sjfke/rhel-ubi8-soma:latest
If you don't see a command prompt, try pressing enter.
[soma@soma-pod ~]$ cat /etc/motd
##############################################################################
#         WARNING: Unauthorized access to this system is forbidden!          #
#                All connections are monitored and recorded.                 #
#         Disconnect IMMEDIATELY if you are not an authorized user!          #
#                                                                            #
# -------------------------------------------------------------------------- #
# Idea stolen from: Brave New World by Aldous Huxley                         #
# SOMA: numbs any sort of discomfort, anxiety, stress and general uneasiness #
# -------------------------------------------------------------------------- #
# sudoers: soma ALL=(ALL) NOPASSWD:ALL                                       #
# nmap-ncat: nc, ncat                                                        #
# bind-utils: nslookup, dig, host, nsupdate, arpaname                        #
# iputils: ping, tracepath; /usr/sbin/: arping, ping[6], tracepath[6]        #
# ip: link, address, route, rule, neigh, maddress, monitor etc.              #
##############################################################################

[soma@soma-pod ~]$ sudo -l
User soma may run the following commands on <pod-name>:
  (ALL) ALL
  (ALL) NOPASSWD: ALL

[soma@soma-pod ~]$ exit
logout
Session ended, resume using 'kubectl attach soma-pod -c soma-pod -i -t' command when the pod is running
pod "soma-pod" deleted
```
#### Deploying to a Kubernetes cluster

```bash
kubeadmin$ oc adm policy add-scc-to-group anyuid system:authenticated --namespace="<project>"
developer$ oc apply -f soma-cli-deployment.yaml
developer$ oc get pods

developer$ oc exec --stdin --tty pod/<pod-name> -- bash --login
[soma@<pod-name> ~]$ id 
uid=1001(soma) gid=1001(soma) groups=1001(soma),10(wheel)
[soma@<pod-name> ~]$ exit
developer$

developer$ oc delete deployment.apps/soma-cli-deployment
kubeadmin$ oc adm policy remove-scc-from-group anyuid system:authenticated --namespace="<project>"
```

```bash
$ kubectl apply -f soma-cli-deployment.yaml
$ kubectl get pods

$ kubectl exec --stdin --tty pod/<pod-name> -- bash --login
[soma@<pod-name> ~]$ id 
uid=1001(soma) gid=1001(soma) groups=1001(soma),10(wheel)
[soma@<pod-name> ~]$ exit
$

$ kubectl delete deployment.apps/soma-cli-deployment
```
#### Testing using ``Docker`` or ``podman``

```bash
$ docker pull docker.io/sjfke/rhel-ubi8-soma:8.6
$ docker run -it --name lazy-dog docker.io/sjfke/rhel-ubi8-soma:8.6
# Docker assumes the docker.io prefix, so the following also works
$ docker pull sjfke/rhel-ubi8-soma:8.6
$ docker run -it --name lazy-dog sjfke/rhel-ubi8-soma:8.6

# For Quay.io containers the <quay.io> prefix MUST BE supplied. 
$ podman pull quay.io/sjfke/rhel-ubi8-soma:8.7
$ podman run -it --name lazy-dog sjfke/rhel-ubi8-soma:8.7

$ docker pull quay.io/sjfke/rhel-ubi8-soma:8.7
$ docker run -it --name lazy-dog quay.io/sjfke/rhel-ubi8-soma:8.7

##############################################################################
#         WARNING: Unauthorized access to this system is forbidden!          #
#                All connections are monitored and recorded.                 #
#         Disconnect IMMEDIATELY if you are not an authorized user!          #
#                                                                            #
# -------------------------------------------------------------------------- #
# Idea stolen from: Brave New World by Aldous Huxley                         #
# SOMA: numbs any sort of discomfort, anxiety, stress and general uneasiness #
# -------------------------------------------------------------------------- #
# sudoers: soma ALL=(ALL) NOPASSWD:ALL                                       #
# nmap-ncat: nc, ncat                                                        #
# bind-utils: nslookup, dig, host, nsupdate, arpaname                        #
# iputils: ping, tracepath; /usr/sbin/: arping, ping[6], tracepath[6]        #
##############################################################################

[soma@32159e02715f ~]$ sudo -l
User soma may run the following commands on 32159e02715f:
  (ALL) ALL
  (ALL) NOPASSWD: ALL

[soma@32159e02715f ~]$ exit
```

## SCC Constraints

The OpenShift Container Platform, has an additional set of *Security Context Constraints* (**SCC**), which control the 
actions a `pod` can perform and what it has the ability to access, as shown below, with **restricted** being the default. 

To ensure the application will deploy and run, it is necessary to ensure the `serviceaccount` of the application which 
is assigned to the correct `SCC policy`.

All containers are governed [SELINUX](https://www.redhat.com/en/topics/linux/what-is-selinux) and have restrictions on 
*RUNASUSER*, for example the *MustRunAsRange* enforces the range `1000660000 -to- 1000669999` for the UNIX `UID` value.

```bash
kubeadmin$ oc get scc
NAME                              PRIV    CAPS                   SELINUX     RUNASUSER          FSGROUP     SUPGROUP    PRIORITY     READONLYROOTFS   VOLUMES
anyuid                            false   <no value>             MustRunAs   RunAsAny           RunAsAny    RunAsAny    10           false            ["configMap","downwardAPI","emptyDir","persistentVolumeClaim","projected","secret"]
hostaccess                        false   <no value>             MustRunAs   MustRunAsRange     MustRunAs   RunAsAny    <no value>   false            ["configMap","downwardAPI","emptyDir","hostPath","persistentVolumeClaim","projected","secret"]
hostmount-anyuid                  false   <no value>             MustRunAs   RunAsAny           RunAsAny    RunAsAny    <no value>   false            ["configMap","downwardAPI","emptyDir","hostPath","nfs","persistentVolumeClaim","projected","secret"]
hostnetwork                       false   <no value>             MustRunAs   MustRunAsRange     MustRunAs   MustRunAs   <no value>   false            ["configMap","downwardAPI","emptyDir","persistentVolumeClaim","projected","secret"]
hostnetwork-v2                    false   ["NET_BIND_SERVICE"]   MustRunAs   MustRunAsRange     MustRunAs   MustRunAs   <no value>   false            ["configMap","downwardAPI","emptyDir","persistentVolumeClaim","projected","secret"]
machine-api-termination-handler   false   <no value>             MustRunAs   RunAsAny           MustRunAs   MustRunAs   <no value>   false            ["downwardAPI","hostPath"]
nonroot                           false   <no value>             MustRunAs   MustRunAsNonRoot   RunAsAny    RunAsAny    <no value>   false            ["configMap","downwardAPI","emptyDir","persistentVolumeClaim","projected","secret"]
nonroot-v2                        false   ["NET_BIND_SERVICE"]   MustRunAs   MustRunAsNonRoot   RunAsAny    RunAsAny    <no value>   false            ["configMap","downwardAPI","emptyDir","persistentVolumeClaim","projected","secret"]
privileged                        true    ["*"]                  RunAsAny    RunAsAny           RunAsAny    RunAsAny    <no value>   false            ["*"]
restricted                        false   <no value>             MustRunAs   MustRunAsRange     MustRunAs   RunAsAny    <no value>   false            ["configMap","downwardAPI","emptyDir","persistentVolumeClaim","projected","secret"]
restricted-v2                     false   ["NET_BIND_SERVICE"]   MustRunAs   MustRunAsRange     MustRunAs   RunAsAny    <no value>   false            ["configMap","downwardAPI","emptyDir","persistentVolumeClaim","projected","secret"]
```
If the deployment fails, it may be possible to determine what `SCC` is required using:

```bash
kubeadmin$ oc get pods
kubeadmin$ oc get pod <pod-name> -o yaml | oc adm scc-subject-review -f - # reading from STDIN '-'
```

The *official* way to handle the ``SCC Constraints`` is:
* Create a `serviceaccount`
* Add `serviceaccount` to the correct `oc adm policy`, most likely `anyuid`
* Update or patch the `deployment` to use the `serviceaccount`

```bash
kubeadmin$ oc create serviceaccount sa-anyuid
kubeadmin$ oc adm policy add-scc-to-user anyuid -z sa-anyuid
developer$ oc set serviceaccount deployment/<app-name> sa-anyuid
```

A simpler approach, which whilst only documented for `OpenShift 3.11` and still works in later releases, is to assign all 
authenticated users to `anyuid`, as described in [`USER` in the `Dockerfile`](https://docs.openshift.com/container-platform/3.11/admin_guide/manage_scc.html).

```bash
# Cluster-wide
kubeadmin$ oc adm policy add-scc-to-group anyuid system:authenticated      # add all authenticated users
kubeadmin$ oc adm policy remove-scc-from-group anyuid system:authenticated # remove all authenticated users

# Project-scoped
kubeadmin$ oc adm policy add-scc-to-group anyuid system:authenticated --namespace="<project>"
kubeadmin$ oc adm policy remove-scc-from-group anyuid system:authenticated --namespace="<project>"
```

The following BLOG post [A Guide to OpenShift and UIDs](https://cloud.redhat.com/blog/a-guide-to-openshift-and-uids) 
provides a more detailed explanation.
