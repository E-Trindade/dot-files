#!/bin/bash

# Config locations
folders="$HOME/bin/folders"
configs="$HOME/bin/configs"

# Output locations
shell_shortcuts="$HOME/.shortcuts"
ranger_shortcuts="$HOME/.config/ranger/shortcuts.conf"
qute_shortcuts="$HOME/.config/qutebrowser/shortcuts.py"

# Shell rc file (i.e. bash vs. zsh, etc.)
shellrc="$HOME/.bashrc"

# Remove
rm -f $shell_shortcuts $ranger_shortcuts $qute_shortcuts

# Ensuring that output locations are properly sourced
(grep "source ~/.shortcuts"  $shellrc)>/dev/null || echo "source ~/.shortcuts" >> $shellrc
(grep "source $HOME/.config/ranger/shortcuts.conf" $HOME/.config/ranger/rc.conf)>/dev/null || echo "source $HOME/.config/ranger/shortcuts.conf" >> $HOME/.config/ranger/rc.conf
(grep "config.source('shortcuts.py')" $HOME/.config/qutebrowser/config.py)>/dev/null || echo "config.source('shortcuts.py')" >> $HOME/.config/qutebrowser/config.py

# directory shortcuts
cat $folders | sed "/^#/d" | awk '{print "alias "$1"=\"cd "$2" && ls -a\""}' >> $shell_shortcuts
cat $folders | sed "/^#/d" | awk '{print "map g"$1" cd "$2"\nmap t"$1" tab_new "$2"\nmap m"$1" shell mv -v %s "$2"\nmap Y"$1" shell cp -rv %s "$2}' >> $ranger_shortcuts
cat $folders | sed "/^#/d" | awk '{print "config.bind(\";"$1"\", \"set downloads.location.directory "$2" ;; hint links download\")"}' >> $qute_shortcuts

# dotfile shortcuts
cat $configs | sed "/^#/d" | awk '{print "alias "$1"=\"$EDITOR "$2"\""}' >> $shell_shortcuts
cat $configs | sed "/^#/d" | awk '{print "map "$1" shell $EDITOR "$2}' >> $ranger_shortcuts
