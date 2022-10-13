#!/bin/bash
#

# Create soma sudoers file
cat  > /etc/sudoers.d/soma <<EOT
soma  ALL=(ALL) NOPASSWD:ALL

EOT
chmod 440 /etc/sudoers.d/soma

# Create motd file
cat > /etc/motd <<EOT
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

EOT
chmod 444 /etc/motd

# Copy /etc/motd /etc/issue.net file
cp -p /etc/motd /etc/issue.net

# Create bash_profile and prevent $TERM expansion
cat > /home/soma/.bash_profile << "EOT"
# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
  . ~/.bashrc
fi

# User specific environment and startup programs

# Display MOTD
if [ ! -z "$TERM" ]; then
  if [ -f /etc/motd ]; then
    cat /etc/motd
  fi
fi

PATH=$PATH:$HOME/bin
export PATH

EOT
chmod 744 /home/soma/.bash_profile

# Create bashrc file
cat > /home/soma/.bashrc <<EOT
# .bashrc"

# Source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

# User specific aliases and functions

EOT
chmod 744 /home/soma/.bashrc

exit 0
