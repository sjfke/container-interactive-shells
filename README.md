# RHEL-8 Universal Base Image Pods and Containers

Guidance for creating pods or containers inside the cluster for troubleshooting and debugging.

Which are based on the [Red Hat Universal Base Image 8](https://catalog.redhat.com/software/containers/ubi8/ubi/5c359854d70cc534b3a3784e) 
or [Docker-IO: redhat/ubi8](https://hub.docker.com/r/redhat/ubi8), 
image, but [BusyBox](https://hub.docker.com/_/busybox) examples are also provided.

If deploying ``OpenShift Kubernetes Environment`` such as [Red Hat OpenShift Local (formerly Red Hat CodeReady Containers)](https://developers.redhat.com/products/openshift-local/overview)
there are an extra level security constraints to be taken into account, [SCC Constraints](#scc-constraints).

## Debug RHEL-8 UBI Pod 


## SomaCLI

RHEL-8 UBI  Interactive with Non-Root Bash Shell with login that provides:

* nmap-ncat, bind-utils, iputils

### Interactive Bash Shell

The RHEL UBI 8 image includes:
* sudoers: with: 'soma ALL=(ALL) NOPASSWD:ALL'
* nmap-ncat: nc, ncat
* bind-utils: nslookup, dig, host, nsupdate, arpaname
* iputils: ping, tracepath; /usr/sbin/: arping, ping[6], tracepath[6]

The original version was based on rhel8-ubi:8.5 but:

* These will be periodically updated based on the quay.io security-scan.
* Issues not yet fixed in the RHEL UBI image are not handled.
* Older releases are (annotated) tagged and pushed to github.
* Updated container images are pushed to docker.io and quay.io.
* Older container images will be periodically removed.

### Websites

* [GitHub: RHEL-8 Universal Base Image Docker Containers](https://github.com/sjfke/rhel8-ubi-containers)
* [Docker.io: sjfke/rhel8-ubi-soma](https://hub.docker.com/repository/docker/sjfke/rhel8-ubi-soma)
* [Quay.io: quay.io/sjfke/rhel8-ubi-soma](https://quay.io/repository/sjfke/rhel8-ubi-soma)
* [Quay.io: quay.io/sjfke/rhel8-ubi-soma - tag history](https://quay.io/repository/sjfke/rhel8-ubi-soma?tab=history)

### Files

* Dockerfile: Docker configuration file.
* BUILDME: Image build, deployment and test.

Generated using: `create-unix-files.sh`

* bashrc: /home/soma/.bashrc
* bash_profile: /home/soma/.bash_profile
* motd: /etc/motd, /etc/issue.net
* soma: /etc/sudoers.d/soma

### Usage

```bash
$ docker pull docker.io/sjfke/rhel8-ubi-soma:8.6
$ docker run -it --name lazy-dog docker.io/sjfke/rhel8-ubi-soma:8.6

# Docker strips the docker.io prefix, so it is effectively

$ docker pull docker pull sjfke/rhel8-ubi-soma:8.6
$ docker run -it --name lazy-dog sjfke/rhel8-ubi-soma:8.6

###############################################################################
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
[soma@32159e02715f ~]$ exit

# For Quay.io containers the quay.io prefix *must be* supplied. 

$ docker pull quay.io/sjfke/rhel8-ubi-soma:8.6
$ docker run -it --name lazy-cat quay.io/sjfke/rhel8-ubi-soma:8.6
```


## SCC Constraints

The OpenShift Container Platform, has an additional set of *Security Context Constraints* (**SCC**), which control the actions a **pod** can perform and what it has the ability to access
as shown below, with **restricted** being the default. 

All containers are governed [SELINUX](https://www.redhat.com/en/topics/linux/what-is-selinux) and have restrictions on **RUNASUSER**,
the **_MustRunAsRange_** for example enforces the range `1000660000 -to- 1000669999` for the UNIX `UID` value.

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
It may be possible to determine what `SCC` is required using:

```bash
kubeadmin$ oc get pods
kubeadmin$ oc get pod <pod-name> -o yaml | oc adm scc-subject-review -f - # reading from STDIN '-'
```

The *official* way to fix this:
* if necessary, create a `serviceaccount`
* add `serviceaccount` to the correct `oc adm policy`, most likely `anyuid`
* if necessary, update or patch the `deployment` to use the `serviceaccount`

```bash
kubeadmin$ oc create serviceaccount sa-anyuid
kubeadmin$ oc adm policy add-scc-to-user anyuid -z sa-anyuid
developer$ oc set serviceaccount deployment/<app-name> sa-anyuid
```

While documented for `OpenShift 3.11`, another simpler approach is to assigning all authenticated users to `anyuid`, as described in [`USER` in the `Dockerfile`](https://docs.openshift.com/container-platform/3.11/admin_guide/manage_scc.html).

```bash
kubeadmin$ oc adm policy add-scc-to-group anyuid system:authenticated      # add all authenticated users
kubeadmin$ oc adm policy remove-scc-from-group anyuid system:authenticated # remove all authenticated users
```

The following BLOG post [A Guide to OpenShift and UIDs](https://cloud.redhat.com/blog/a-guide-to-openshift-and-uids) provides a more detailed explanation.
