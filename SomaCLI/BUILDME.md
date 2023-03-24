# Soma CLI Building

RHEL UBI-8 Interactive non-root Bash Shell with nmap-ncat, bind-utils, iputils

The build instructions reflect the initial build using UBI-8.5, for rebuilding see [Updating quay.io and dockerhub images](#updating-quay.io-and-dockerhub-images) 

> A UNIX script is used to create the configuration files in the container to ensure correct line-endings, see also [Configuring Git to handle line endings](#configuring-git-to-handle-line-endings)

## DockerHub using Windows Docker Desktop

* [DockerHub: Repositories](https://docs.docker.com/docker-hub/repos/)
* [DockerHub: Personal Access Tokens](https://www.docker.com/blog/docker-hub-new-personal-access-tokens/)
* [DockerHub: Manage access tokens](https://docs.docker.com/docker-hub/access-tokens/)

### Docker Local build, deploy and test

```powershell
PS1> docker login docker.io -u sjfke
PS1> cat dockerhub-win10-access-token.txt | docker login -u sjfke --password-stdin

# Build, deploy and test
PS1> docker images
REPOSITORY                            TAG       IMAGE ID       CREATED        SIZE
registry.access.redhat.com/ubi8/ubi   8.5       202c1768b1f7   3 months ago   216MB

PS1> docker build --no-cache --tag sjfke/rhel-ubi8-containers/rhel-ubi8-soma:8.5 -f ./Dockerfile $pwd
PS1> docker run -it --name crazy-frog sjfke/rhel-ubi8-containers/rhel-ubi8-soma:8.5
```
### Tag and Push to DockerHub

* [tutorialspoint.com: Docker - Public Repositories](https://www.tutorialspoint.com/docker/docker_public_repositories.htm)

```powershell
PS1> docker images
REPOSITORY                                  TAG       IMAGE ID       CREATED         SIZE
sjfke/rhel-ubi8-containers/rhel-ubi8-soma   8.5       45766b337ea4   4 minutes ago   302MB
registry.access.redhat.com/ubi8/ubi         8.5       202c1768b1f7   3 months ago    216MB

PS1> docker tag 45766b337ea4 sjfke/rhel-ubi8-soma:8.5 # tag with <repo>:<image-version>
PS1> docker images
REPOSITORY                                  TAG       IMAGE ID       CREATED          SIZE
sjfke/rhel-ubi8-containers/rhel-ubi8-soma   8.5       45766b337ea4   10 minutes ago   302MB
sjfke/rhel-ubi8-soma                        8.5       45766b337ea4   10 minutes ago   302MB
registry.access.redhat.com/ubi8/ubi         8.5       202c1768b1f7   3 months ago     216MB

PS1> docker push sjfke/rhel-ubi8-soma:8.5 # push tag with <repo>:<image-version>
The push refers to repository [docker.io/sjfke/rhel-ubi8-soma]
ad2f2a87562f: Pushed
97af94709826: Pushed
0fbfed2f82f5: Pushed
d49d5ba4975c: Pushed
173c4699f0ae: Pushed
c86122b5e4d3: Pushed
3813924f3fa4: Pushed
8.5: digest: sha256:a27d6433f7d069aa4db58e1849b203f52c1b29731ada64b17bd24ff2f4997705 size: 1778

```
## Quay.IO using RHEL Podman

### Podman Local build, deploy and test

* [Quay.IO: Robot Accounts](http://docs.quay.io/glossary/robot-accounts.html)

```bash
$ podman login quay.io -u sjfke
$ podman login -u=<robot-account> -p=<robot-account-password> quay.io

# Build, deploy and test
$ podman build --no-cache --tag quay.io/sjfke/rhel-ubi8-soma:8.5 -f ./Dockerfile $PWD
$ podman run -it --name crazy-toad quay.io/sjfke/rhel-ubi8-soma:8.5
```

### Commit container and Push to Quay.IO

* [Quay.IO: Getting Started with Quay.io](http://docs.quay.io/solution/getting-started.html)

```bash
$ podman images
REPOSITORY                               TAG         IMAGE ID      CREATED             SIZE
quay.io/sjfke/rhel-ubi8-soma             8.5         2cf12092c3ef  About a minute ago  321 MB
registry.access.redhat.com/ubi8/ubi      8.5         202c1768b1f7  3 months ago        235 MB

$ podman ps -l
CONTAINER ID  IMAGE                             COMMAND               CREATED        STATUS                    PORTS       NAMES
b4826e4acf63  quay.io/sjfke/rhel-ubi8-soma:8.5  /bin/sh -c /bin/b...  8 minutes ago  Exited (0) 8 minutes ago              crazy-toad


$ podman commit b4826e4acf63 quay.io/sjfke/rhel-ubi8-soma:8.5 # tag the container with <repo>:<image-version>
$ podman container ls -a
CONTAINER ID  IMAGE                             COMMAND               CREATED         STATUS                     PORTS       NAMES
b4826e4acf63  quay.io/sjfke/rhel-ubi8-soma:8.5  /bin/sh -c /bin/b...  14 minutes ago  Exited (0) 14 minutes ago              crazy-toad

$ podman images
REPOSITORY                               TAG         IMAGE ID      CREATED        SIZE
quay.io/sjfke/rhel-ubi8-soma             8.5         2cf12092c3ef  2 minutes ago  321 MB
registry.access.redhat.com/ubi8/ubi      8.5         202c1768b1f7  3 months ago   235 MB

$ podman push quay.io/sjfke/rhel-ubi8-soma:8.5 # push tag with <repo>:<image-version>
Getting image source signatures
Copying blob 1b7b9bd03f60 done  
Copying blob f9535e3067b1 done  
Copying blob d2991ce7a82b done  
Copying blob 844ad7a91e17 done  
Copying blob 3813924f3fa4 skipped: already exists  
Copying blob c86122b5e4d3 skipped: already exists  
Copying blob 5f70bf18a086 done  
Copying config 93c4de9533 done  
Writing manifest to image destination
Storing signatures
```
## Updating quay.io and dockerhub images

After updating the Docker file, to rebuild and push, this is for 8.5 to 8.6.

```powershell
# Docker.IO (DockerHub)
PS1> cat <dockerhub-win10-access-token.txt> | docker login -u sjfke --password-stdin
PS1> docker build --no-cache --tag sjfke/rhel-ubi8-soma:8.6 -f ./Dockerfile-8.6 $pwd
PS1> docker run -it --name crazy-frog sjfke/rhel-ubi8-soma:8.6
PS1> docker images | select -first 5 # need IMAGE ID for tag
PS1> docker tag b5244edad760 sjfke/rhel-ubi8-soma:8.6
PS1> docker push sjfke/rhel-ubi8-soma:8.6

# Quay.IO
PS1> cat <sjfke+quay_io_robot.txt> | docker login -u <sjfke+quay_io> --password-stdin quay.io
PS1> docker build --no-cache --tag quay.io/sjfke/rhel-ubi8-soma:8.6 -f ./Dockerfile-8.6 $pwd # NB quay.io prefix
PS1> docker run -it --name crazy-toad quay.io/sjfke/rhel-ubi8-soma:8.6
PS1> docker stop crazy-toad # do not 'docker rm' because need CONTAINER ID for commit
PS1> docker ps -l # need CONTAINER ID for commit
PS1> docker commit 88e6303c47c2 quay.io/sjfke/rhel-ubi8-soma:8.6
PS1> docker push quay.io/sjfke/rhel-ubi8-soma:8.6
PS1> docker rm crazy-toad # now clean-up
```

```bash
# Docker.IO (DockerHub)
$ cat <dockerhub-fedora-access-token.txt> | podman login --username sjfke --password-stdin docker.io
$ podman login --get-login docker.io # confirm user login

$ podman build --no-cache --tag sjfke/rhel-ubi8-soma:8.6 -f ./Dockerfile $pwd
$ podman run -it --name crazy-frog sjfke/rhel-ubi8-soma:8.6
$ podman images # need IMAGE ID for tag
$ podman tag b5244edad760 sjfke/rhel-ubi8-soma:8.6
$ podman push sjfke/rhel-ubi8-soma:8.6

# Quay.IO
$ cat <sjfke+quay_io_robot.txt> | podman login --username <sjfke+quay_io> --password-stdin quay.io
$ podman login --get-login quay.io # confirm user login
$ podman build --no-cache --tag quay.io/sjfke/rhel-ubi8-soma:8.6 -f ./Dockerfile $PWD
$ podman run -it --name crazy-toad quay.io/sjfke/rhel-ubi8-soma:8.6
$ podman stop crazy-toad # do not 'podman rm' because need CONTAINER ID for commit
$ podman ps -l # need CONTAINER ID for commit
$ podman commit 88e6303c47c2 quay.io/sjfke/rhel-ubi8-soma:8.6
$ podman push quay.io/sjfke/rhel-ubi8-soma:8.6
$ podman rm crazy-toad # now clean-up
```

## Run Soma in Kubernetes Container Platform

```bash
# Openshift Container Platform - add all authenticated users to SCC group policy 'anyuid' 
kubeadmin$ oc adm policy add-scc-to-group anyuid system:authenticated --namespace="<project>"

developer$ oc debug --tty --image docker.io/sjfke/rhel-ubi8-soma:8.6
# or
developer$ oc run soma-pod --rm -i --tty --image docker.io/sjfke/rhel-ubi8-soma:8.6
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
[soma@soma-pod ~]$ exit
logout
Session ended, resume using 'oc attach soma-pod -c soma-pod -i -t' command when the pod is running
pod "soma-pod" deleted

# Openshift Container Platform - remove all authenticated users from SCC group policy 'anyuid'
kubeadmin$ oc adm policy remove-scc-from-group anyuid system:authenticated --namespace="<project>"
```

## Configuring Git to handle line endings

To avoid Windows/MacOS Unix line ending madness when using GIT, needs configuring.
Files are best generated during the Docker installation using a script (create-unix-files.sh)

* [docs.github.com: Handling line endings](https://docs.github.com/en/get-started/getting-started-with-git/configuring-git-to-handle-line-endings)

If Git Large File Support (LFS) as suggested in:
* [rehansaeed.com: gitattributes Best Practices](https://rehansaeed.com/gitattributes-best-practices/)
* 2022-09-07: CAUTION: this can cause issues with your external repository provider.
* 2022-09-07: GitHub currently requires an additional paid-for data plan even for a 6K favicon file flagged as lfs.
* 2022-09-07: For binary files flag as 'binary' as shown in the '.gitattributes' file.

```powershell
PS1> git config --global core.autocrlf true # Global settings for line endings
PS1> cat <repo>\.git\info\gitattributes
# Set the default behavior, in case people don't have core.autocrlf set.
* text=auto

# Explicitly declare text files you want to always be normalized and converted
# to native line endings on checkout.
*.c text
*.h text

# Declare files that will always have CRLF line endings on checkout.
*.sln text eol=crlf

# Denote all files that are truly binary and should not be modified.
*.png binary
*.jpg binary

# Force Bash Shell scripts to UNIX LF
*.sh text eol=lf
```