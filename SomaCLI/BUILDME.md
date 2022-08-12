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

### Local build, deploy and test

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

```bash
$ podman login quay.io -u sjfke

# Build, deploy and test
$ podman build --tag quay.io/sjfke/rhel8-ubi-containers/rhel85-ubi-soma:0.1.0 -f ./Dockerfile $PWD
$ podman run -it --name crazy-toad sjfke/rhel8-ubi-containers/rhel85-ubi-soma:0.1.0

$ podman images
REPOSITORY                                            TAG         IMAGE ID      CREATED        SIZE
quay.io/sjfke/rhel8-ubi-containers/rhel85-ubi-soma    0.1.0       0518a1f14b02  2 hours ago    321 MB
registry.access.redhat.com/ubi8/ubi                   8.5         202c1768b1f7  3 months ago   235 MB
$ podman push quay.io/sjfke/rhel8-ubi-containers/rhel85-ubi-soma:0.1.0
```
