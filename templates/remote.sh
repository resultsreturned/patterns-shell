# remote templates
# Template functions for managing a connection to an SSH server
# and pushing and pulling files via SCP
#
# Copyright (C) 2013 Mara Kim
#
# This program is free software: you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later
# version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
# details.
#
# You should have received a copy of the GNU General Public License along with
# this program. If not, see http://www.gnu.org/licenses/.


### USAGE ###

# Source ../scripts/remote.sh in your shell's .*rc file
# Then use template-remote to create your functions
# See README.md for more info


### TEMPLATE ###

# output three function definitons
# * access server via SSH
# * push file to server via SCP
# * pull file from server via SCP
# ex.
# source <(template-remote "myconnection" "myserver" "myuser" "myscpdir")
# * myconnection [OPTION] [command]
# * myconnection-push [OPTION] [file]
# * myconnection-pull [OPTION] [file]
# all functions are self documenting (-h)
function template-remote {

local MYCONNECTION=$1
local MYSERVER=$2
local MYUSER=$3
local MYSCPDIR=$4

cat << TEMPLATE 
# SSH connection function
function $MYCONNECTION {
if [ "\$1" = "-h" -o "\$1" = "--help" ]
then
 # show help
 echo "Usage: $MYCONNECTION [OPTION] [command]
Connect via SSH to $MYSERVER
If a command is given as an argument, execute it remotely,
otherwise start an ssh session connected to $MYSERVER.
Option		GNU long option		Meaning
-h		--help			Show this message
-X					Enable X11 forwarding"
elif [ "\$1" = "-X" ]
then
 # enable X11 forwarding
 ssh-connection "$MYSERVER" "$MYUSER" "\$2" "\$1"
else
 ssh-connection "$MYSERVER" "$MYUSER" "\$1"
fi
}

# SCP push function
function $MYCONNECTION-push {
if [ "\$1" = "-h" -o "\$1" = "--help" ]
then
 # show help
 echo "Usage: $MYCONNECTION-push [OPTION] [file]
Push file to $MYSCPDIR/ at $MYSERVER
Option		GNU long option		Meaning
-h		--help			Show this message"
else
 scp-push "$MYSERVER" "$MYUSER" "$MYSCPDIR/\$1"
fi
}

# SCP pull function
function $MYCONNECTION-pull {
if [ "\$1" = "-h" -o "\$1" = "--help" ]
then
 # show help
 echo "Usage: $MYCONNECTION-pull [OPTION] [file]
Pull file from $MYSCPDIR/ at $MYSERVER
Option		GNU long option		Meaning
-h		--help			Show this message"
else
 scp-pull "$MYSERVER" "$MYUSER" "$MYSCPDIR/\$1"
fi
}
TEMPLATE

} # function template-remote
