# Soma CLI Building

RHEL-8 UBI Interactive Non-Root Bash Shell with nmap-ncat, bind-utils, iputils

## DockerHub using Windows Docker Desktop

* [DockerHub Repositories](https://docs.docker.com/docker-hub/repos/)

```powershell
PS1> docker login docker.io -u sjfke

PS1> docker build --no-cache --tag sjfke/rhel8-ubi-containers/rhel85-ubi-soma:0.1.0 -f ./Dockerfile $pwd
PS1> docker run -it --name crazy-frog sjfke/rhel8-ubi-containers/rhel85-ubi-soma:0.1.0

PS1> docker images
REPOSITORY                                   TAG       IMAGE ID       CREATED        SIZE
rhel8-ubi-containers                         0.1.0     e0efe0749389   2 hours ago    302MB
sjfke/rhel8-ubi-containers/rhel85-ubi-soma   0.1.0     e0efe0749389   2 hours ago    302MB
sjfke/rhel8-ubi-containers                   0.1.0     e0efe0749389   2 hours ago    302MB
localhost/rhel85-ubi-soma                    0.1.0     2d7e2b0b3b6b   46 hours ago   302MB
registry.access.redhat.com/ubi8/ubi          8.5       202c1768b1f7   3 months ago   216MB

PS1> docker tag sjfke/rhel8-ubi-containers/rhel85-ubi-soma:0.1.0 sjfke/rhel8-ubi-containers:0.1.0
PS1> docker push rhel8-ubi-containers:0.1.0
```
## Quay.IO using RHEL Podman

```bash
$ podman login quay.io -u sjfke

$ podman build --tag quay.io/sjfke/rhel8-ubi-containers/rhel85-ubi-soma:0.1.0 -f ./Dockerfile $PWD

$ podman images
REPOSITORY                                            TAG         IMAGE ID      CREATED        SIZE
quay.io/sjfke/rhel8-ubi-containers/rhel85-ubi-soma    0.1.0       0518a1f14b02  2 hours ago    321 MB
registry.access.redhat.com/ubi8/ubi                   8.5         202c1768b1f7  3 months ago   235 MB
$ podman push quay.io/sjfke/rhel8-ubi-containers/rhel85-ubi-soma:0.1.0
```
