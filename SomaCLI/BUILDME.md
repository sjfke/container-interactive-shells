# Soma CLI Building

RHEL-8 UBI Interactive Non-Root Bash Shell with nmap-ncat, bind-utils, iputils

## Configuring Git to handle line endings

To avoid Windows/MacOS Unix line ending madness when using GIT, needs configuring.
Files are best generated during the Docker installation using a script (create-unix-files.sh)

* [docs.github.com: Handling line endings](https://docs.github.com/en/get-started/getting-started-with-git/configuring-git-to-handle-line-endings)
* [rehansaeed.com: gitattributes Best Practices](https://rehansaeed.com/gitattributes-best-practices/)

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

## DockerHub using Windows Docker Desktop

* [DockerHub Repositories](https://docs.docker.com/docker-hub/repos/)

### Docker Local build, deploy and test

```powershell
PS1> docker login docker.io -u sjfke
PS1> cat dockerhub-win10-access-token.txt | docker login -u sjfke --password-stdin

# Build, deploy and test
PS1> docker images
REPOSITORY                            TAG       IMAGE ID       CREATED        SIZE
registry.access.redhat.com/ubi8/ubi   8.5       202c1768b1f7   3 months ago   216MB

PS1> docker build --no-cache --tag sjfke/rhel8-ubi-containers/rhel8-ubi-soma:8.5 -f ./Dockerfile $pwd
PS1> docker run -it --name crazy-frog sjfke/rhel8-ubi-containers/rhel8-ubi-soma:8.5
```
### Tag and Push to DockerHub

* [tutorialspoint.com: Docker - Public Repositories](https://www.tutorialspoint.com/docker/docker_public_repositories.htm)

```powershell
PS1> docker images
REPOSITORY                                  TAG       IMAGE ID       CREATED         SIZE
sjfke/rhel8-ubi-containers/rhel8-ubi-soma   8.5       45766b337ea4   4 minutes ago   302MB
registry.access.redhat.com/ubi8/ubi         8.5       202c1768b1f7   3 months ago    216MB

PS1> docker tag 45766b337ea4 sjfke/rhel8-ubi-soma:8.5 # tag with <repo>:<image-version>
PS1> docker images
REPOSITORY                                  TAG       IMAGE ID       CREATED          SIZE
sjfke/rhel8-ubi-containers/rhel8-ubi-soma   8.5       45766b337ea4   10 minutes ago   302MB
sjfke/rhel8-ubi-soma                        8.5       45766b337ea4   10 minutes ago   302MB
registry.access.redhat.com/ubi8/ubi         8.5       202c1768b1f7   3 months ago     216MB

PS1> docker push sjfke/rhel8-ubi-soma:8.5 # push tag with <repo>:<image-version>
The push refers to repository [docker.io/sjfke/rhel8-ubi-soma]
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
$ podman build --no-cache --tag quay.io/sjfke/rhel8-ubi-soma:8.5 -f ./Dockerfile $PWD
$ podman run -it --name crazy-toad quay.io/sjfke/rhel8-ubi-soma:8.5

### Commit container and Push to Quay.IO

* [Quay.IO: Getting Started with Quay.io](http://docs.quay.io/solution/getting-started.html)

$ podman images
REPOSITORY                               TAG         IMAGE ID      CREATED             SIZE
quay.io/sjfke/rhel8-ubi-soma             8.5         2cf12092c3ef  About a minute ago  321 MB
registry.access.redhat.com/ubi8/ubi      8.5         202c1768b1f7  3 months ago        235 MB

$ podman ps -l
CONTAINER ID  IMAGE                             COMMAND               CREATED        STATUS                    PORTS       NAMES
b4826e4acf63  quay.io/sjfke/rhel8-ubi-soma:8.5  /bin/sh -c /bin/b...  8 minutes ago  Exited (0) 8 minutes ago              crazy-toad


$ podman commit b4826e4acf63 quay.io/sjfke/rhel8-ubi-soma:8.5 # tag the container with <repo>:<image-version>
$ podman container ls -a
CONTAINER ID  IMAGE                             COMMAND               CREATED         STATUS                     PORTS       NAMES
b4826e4acf63  quay.io/sjfke/rhel8-ubi-soma:8.5  /bin/sh -c /bin/b...  14 minutes ago  Exited (0) 14 minutes ago              crazy-toad

$ podman images
REPOSITORY                               TAG         IMAGE ID      CREATED        SIZE
quay.io/sjfke/rhel8-ubi-soma             8.5         2cf12092c3ef  2 minutes ago  321 MB
registry.access.redhat.com/ubi8/ubi      8.5         202c1768b1f7  3 months ago   235 MB

$ podman push quay.io/sjfke/rhel8-ubi-soma:8.5 # push tag with <repo>:<image-version>
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
## Updating quay.io and dockerhub using docker

After updating the Docker file, to rebuild and push, this is for 8.5 to 8.6.

```powershell
# Docker
PS1> cat <dockerhub-win10-access-token.txt> | docker login -u sjfke --password-stdin
PS1> docker build --no-cache --tag sjfke/rhel8-ubi-soma:8.6 -f ./Dockerfile $pwd
PS1> docker run -it --name crazy-frog sjfke/rhel8-ubi-soma:8.6
PS1> docker images # need IMAGE ID for tag
PS1> docker tag b5244edad760 sjfke/rhel8-ubi-soma:8.6
PS1> docker push sjfke/rhel8-ubi-soma:8.6

# Quay.IO
PS1> docker login -u=<robot-account> -p=<password-hash> quay.io
PS1> docker build --no-cache --tag quay.io/sjfke/rhel8-ubi-soma:8.6 -f ./Dockerfile $pwd # NB quay.io prefix
PS1> docker run -it --name crazy-toad quay.io/sjfke/rhel8-ubi-soma:8.6
PS1> docker ps -l # need CONTAINER ID for commit
PS1> docker commit 88e6303c47c2 quay.io/sjfke/rhel8-ubi-soma:8.6
PS1> docker push quay.io/sjfke/rhel8-ubi-soma:8.6
```