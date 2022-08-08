FROM registry.access.redhat.com/ubi8/ubi:8.5
MAINTAINER Sjfke <gcollis@ymail.com>

# TODO: Rename the builder environment variable to inform users about application you provide them
# ENV BUILDER_VERSION 1.0

# TODO: Set labels used in OpenShift to describe the builder image
LABEL io.k8s.name="rhel8-ubi:8.5" \
      io.k8s.description="RHEL8 UBI with netcat, bind, iputils" \
      io.k8s.display-name="rhel8-ubi" \
      io.k8s.version="0.1.0" \
      io.openshift.tags="rhel8-ubi,0.1.0"

WORKDIR /home/soma

RUN yum --disableplugin=subscription-manager -y install sudo.x86_64 nmap-ncat.x86_64 bind-utils.x86_64 iputils.x86_64 \
  && yum --disableplugin=subscription-manager clean all
  
# Drop the root user and make this an interactive Bash Shell for user 1001 (soma)
RUN groupadd --gid 1001 soma
RUN useradd --home-dir /home/soma --create-home --shell /bin/bash --uid 1001 --gid 1001 --groups 10 --comment 'soma sudo account' soma
COPY soma /etc/sudoers.d/soma
RUN chmod 440 /etc/sudoers.d/soma
COPY motd /etc/motd
RUN chmod 444 /etc/motd
COPY motd /etc/issue.net
RUN chmod 444 /etc/issue.net
COPY bash_profile /home/soma/.bash_profile
RUN chmod 744 /home/soma/.bash_profile
COPY bashrc /home/soma/.bashrc
RUN chmod 744 /home/soma/.bashrc
USER 1001


# This default user is created in the openshift/base-centos7 image
USER 1001

# TODO: Set the default port for applications built using this image
# EXPOSE ${PORT}

# TODO: Set the default CMD for the image
CMD /bin/bash -li