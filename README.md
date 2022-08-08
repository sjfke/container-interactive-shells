# RHEL Universal Base Image Docker Containers 'rhel85-ubi-containers'

A collection of simple command line Docker containers for troubleshooting and debugging.

## SomaCLI

RHEL UBI-8-5 Interactive Non-Root Bash Shell with nmap-ncat, bind-utils, iputils

### Interacive Bash Shell

The RHEL UBI 8-5 image includes:
* sudoers: with: 'soma ALL=(ALL) NOPASSWD:ALL'
* nmap-ncat: nc, ncat
* bind-utils: nslookup, dig, host, nsupdate, arpaname
* iputils: ping, tracepath; /usr/sbin/: arping, ping[6], tracepath[6]

### Files

* Dockerfile: Docker configuration file
* bashrc: /home/soma/.bashrc
* bash_profile: /home/soma/.bash_profile
* motd: /etc/motd, /etc/issue.net
* soma: /etc/sudoers.d/soma

### Usage

```bash
$ docker pull docker.io/sjfke/rhel85-ubi-soma:0.1.0
$ docker run -it --name lazy-dog docker.io/rhel85-ubi-soma:0.1.0

##############################################################################
#         WARNING: Unauthorized access to this system is forbidden!          #
#                All connections are monitored and recorded.                 #
#         Disconnect IMMEDIATELY if you are not an authorized user!          #
#                                                                            #
# -------------------------------------------------------------------------- #
# Username stolen from: Brave New World by Aldous Huxley                     #
# SOMA: numbs any sort of discomfort, anxiety, stress and general uneasiness #
# -------------------------------------------------------------------------- #
# sudoers: soma ALL=(ALL) NOPASSWD:ALL                                       #
# nmap-ncat: nc, ncat                                                        #
# bind-utils: nslookup, dig, host, nsupdate, arpaname                        #
# iputils: ping, tracepath; /usr/sbin/: arping, ping[6], tracepath[6]        #
##############################################################################

[soma@32159e02715f ~]$ sudo -l
[soma@32159e02715f ~]$ exit

From Quay.io:
$ docker pull quay.io/sjfke/rhel85-ubi-soma:0.1.0
$ docker run -it --name lazy-cat quay.io/rhel85-ubi-soma:0.1.0
```