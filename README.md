# RHEL-8 Universal Base Image Docker Containers

A collection of simple command line Docker containers for troubleshooting and debugging based on the RHEL-8 UBI image.

## SomaCLI

RHEL-8 UBI  Interactive with Non-Root Bash Shell with login that provides:

* nmap-ncat, bind-utils, iputils

### Interacive Bash Shell

The RHEL UBI 8-5 image includes:
* sudoers: with: 'soma ALL=(ALL) NOPASSWD:ALL'
* nmap-ncat: nc, ncat
* bind-utils: nslookup, dig, host, nsupdate, arpaname
* iputils: ping, tracepath; /usr/sbin/: arping, ping[6], tracepath[6]

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
$ docker pull docker.io/sjfke/rhel8-ubi-soma:8.5
$ docker run -it --name lazy-dog docker.io/sjfke/rhel8-ubi-soma:8.5

# Docker strips the docker.io prefix, so it is effectively

$ docker pull docker pull sjfke/rhel8-ubi-soma:8.5
$ docker run -it --name lazy-dog sjfke/rhel8-ubi-soma:8.5

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

# Quay.io: Still to deploy and test
From Quay.io:
$ docker pull quay.io/sjfke/rhel8-ubi-soma:8.5
$ docker run -it --name lazy-cat quay.io/rhel8-ubi-soma:8.5
```
