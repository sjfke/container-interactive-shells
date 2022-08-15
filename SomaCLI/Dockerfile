# syntax=docker/dockerfile:1

FROM registry.access.redhat.com/ubi8/ubi:8.6

# TODO: Rename the builder environment variable to inform users about application you provide them
# ENV BUILDER_VERSION 1.0

# TODO: Set labels used in OpenShift to describe the builder image
LABEL io.k8s.name="rhel8-ubi:8.6" \
      io.k8s.description="RHEL8 UBI with netcat, bind, iputils" \
      io.k8s.display-name="rhel8-ubi" \
      io.k8s.version="8.6" \
      io.openshift.tags="rhel8-ubi,8.6"

WORKDIR /home/soma

RUN yum --disableplugin=subscription-manager -y install sudo.x86_64 nmap-ncat.x86_64 bind-utils.x86_64 iputils.x86_64 \
  && yum --disableplugin=subscription-manager clean all
  
# Drop the root user and make this an interactive Bash Shell for user 1001 (soma)
RUN groupadd --gid 1001 soma \
  && useradd --home-dir /home/soma --create-home --shell /bin/bash --uid 1001 --gid 1001 --groups 10 --comment 'soma sudo account' soma

################################################################
# To avoid Windows/MacOS Unix line ending madness when using GIT
# Files are best generated during the Docker installation
# See:
# https://docs.github.com/en/get-started/getting-started-with-git/configuring-git-to-handle-line-endings
# https://rehansaeed.com/gitattributes-best-practices/
################################################################
 
# Create the following files using: create-unix-files.sh (Unix format)
# root: /etc/sudoers.d/soma, /etc/motd, /etc/issue.net
# soma: /home/soma/.bash_profile, /home/soma/.bashrc

COPY scripts/create-unix-files.sh /tmp/
RUN chmod 755 /tmp/create-unix-files.sh && /tmp/create-unix-files.sh && rm /tmp/create-unix-files.sh

USER 1001

# TODO: Set the default port for applications built using this image
# EXPOSE ${PORT}

CMD /bin/bash -li
