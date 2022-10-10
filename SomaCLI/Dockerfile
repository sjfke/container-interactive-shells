# syntax=docker/dockerfile:1
FROM registry.access.redhat.com/ubi8/ubi:8.6
# Change User to perform privileged actions
USER 0
# TODO: Rename the builder environment variable to inform users about application you provide them
# ENV BUILDER_VERSION 1.0
ENV UID=1001
ENV WHEEL=10

# TODO: Set labels used in OpenShift to describe the builder image
LABEL io.k8s.name="rhel8-ubi:8.6" \
      io.k8s.description="RHEL8 UBI with netcat, bind, iputils, iproute.x86_64" \
      io.k8s.display-name="rhel8-ubi" \
      io.k8s.version="8.6" \
      io.openshift.tags="rhel8-ubi,8.6"

WORKDIR /home/soma

RUN yum --disableplugin=subscription-manager -y install sudo.x86_64 nmap-ncat.x86_64 bind-utils.x86_64 iputils.x86_64 \
 iproute.x86_64 && yum --disableplugin=subscription-manager clean all
  
# Drop the root user and make this an interactive Bash Shell for user 1001 (soma)
RUN groupadd --gid ${UID} soma \
  && useradd --home-dir /home/soma --create-home --shell /bin/bash --uid ${UID} --gid ${UID} --groups ${WHEEL} --comment 'soma sudo account' soma

########################################################################################################
### To avoid Windows/MacOS Unix line ending madness when using GIT on Windows
# https://docs.github.com/en/get-started/getting-started-with-git/configuring-git-to-handle-line-endings
# https://rehansaeed.com/gitattributes-best-practices/
########################################################################################################
 
# Create the following files using: create-unix-files.sh (Unix format)
# root: /etc/sudoers.d/soma, /etc/motd, /etc/issue.net
# soma: /home/soma/.bash_profile, /home/soma/.bashrc
COPY scripts/create-unix-files.sh /tmp/
RUN chmod 755 /tmp/create-unix-files.sh && /tmp/create-unix-files.sh && rm /tmp/create-unix-files.sh

USER ${UID}

# DO NOT SET a default port for applications built using this image
# EXPOSE ${PORT}

ENTRYPOINT exec /bin/bash -login
# CMD ["/bin/bash","-c","while true ; do date; sleep 1; done;"]
# CMD ["/bin/bash","-c","while true ; do sleep 1; done;"]
