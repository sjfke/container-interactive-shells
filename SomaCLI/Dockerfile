# syntax=docker/dockerfile:1

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

################################################################
# To avoid Windows/MacOS Unix line ending madness when using GIT
# Files need to be generated during the Docker installation
################################################################

# Create soma sudoers file
# RUN echo "soma  ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/soma
# RUN echo "" >> /etc/sudoers.d/soma
# RUN chmod 440 /etc/sudoers.d/soma

COPY scripts/create-unix-files.sh /tmp/
RUN chmod 755 /tmp/create-unix-files.sh 
RUN /tmp/create-unix-files.sh 
# # Create motd file
# RUN echo "##############################################################################" > /etc/motd 
# RUN echo "#         WARNING: Unauthorized access to this system is forbidden!          #" >> /etc/motd 
# RUN echo "#                All connections are monitored and recorded.                 #" >> /etc/motd 
# RUN echo "#         Disconnect IMMEDIATELY if you are not an authorized user!          #" >> /etc/motd 
# RUN echo "#                                                                            #" >> /etc/motd 
# RUN echo "# -------------------------------------------------------------------------- #" >> /etc/motd 
# RUN echo "# Idea stolen from: Brave New World by Aldous Huxley                         #" >> /etc/motd 
# RUN echo "# SOMA: numbs any sort of discomfort, anxiety, stress and general uneasiness #" >> /etc/motd 
# RUN echo "# -------------------------------------------------------------------------- #" >> /etc/motd 
# RUN echo "# sudoers: soma ALL=(ALL) NOPASSWD:ALL                                       #" >> /etc/motd 
# RUN echo "# nmap-ncat: nc, ncat                                                        #" >> /etc/motd 
# RUN echo "# bind-utils: nslookup, dig, host, nsupdate, arpaname                        #" >> /etc/motd 
# RUN echo "# iputils: ping, tracepath; /usr/sbin/: arping, ping[6], tracepath[6]        #" >> /etc/motd 
# RUN echo "##############################################################################" >> /etc/motd 
# RUN echo "" >> /etc/motd
# RUN chmod 444 /etc/motd

# Copy /etc/motd /etc/issue.net file
# RUN cp /etc/motd /etc/issue.net
# RUN chmod 444 /etc/issue.net

# Create bash_profile
# RUN echo "# .bash_profile" > /home/soma/.bash_profile
# RUN echo "" >> /home/soma/.bash_profile
# RUN echo "# Get the aliases and functions" >> /home/soma/.bash_profile
# RUN echo "if [ -f ~/.bashrc ]; then" >> /home/soma/.bash_profile
# RUN echo "  . ~/.bashrc" >> /home/soma/.bash_profile
# RUN echo "fi" >> /home/soma/.bash_profile
# RUN echo "" >> /home/soma/.bash_profile
# RUN echo "# User specific environment and startup programs" >> /home/soma/.bash_profile
# RUN echo "" >> /home/soma/.bash_profile
# RUN echo "# Display MOTD" >> /home/soma/.bash_profile
# RUN echo "if [ ! -z "$TERM" ]; then" >> /home/soma/.bash_profile
# RUN echo "  if [ -f /etc/motd ]; then" >> /home/soma/.bash_profile
# RUN echo "    cat /etc/motd" >> /home/soma/.bash_profile
# RUN echo "  fi" >> /home/soma/.bash_profile
# RUN echo "fi" >> /home/soma/.bash_profile
# RUN echo "" >> /home/soma/.bash_profile
# RUN echo "PATH=$PATH:$HOME/bin" >> /home/soma/.bash_profile
# RUN echo "" >> /home/soma/.bash_profile
# RUN echo "export PATH" >> /home/soma/.bash_profile
# RUN echo "" >> /home/soma/.bash_profile
# RUN chmod 744 /home/soma/.bash_profile

# Create bashrc file
# RUN echo "# .bashrc" > /home/soma/.bashrc
# RUN echo "" >> /home/soma/.bashrc
# RUN echo "# Source global definitions" >> /home/soma/.bashrc
# RUN echo "if [ -f /etc/bashrc ]; then" >> /home/soma/.bashrc
# RUN echo "  . /etc/bashrc" >> /home/soma/.bashrc
# RUN echo "fi" >> /home/soma/.bashrc
# RUN echo "" >> /home/soma/.bashrc
# RUN echo "# User specific aliases and functions" >> /home/soma/.bashrc
# RUN echo "" >> /home/soma/.bashrc
# RUN chmod 744 /home/soma/.bashrc

USER 1001

# TODO: Set the default port for applications built using this image
# EXPOSE ${PORT}

# TODO: Set the default CMD for the image
CMD /bin/bash -li
