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
