# remote templates
# Pattern examples for managing a connection to an SSH server
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

# then copy the example functions below into a new file
# and edit for your needs
#
# DO NOT edit the examples in this file directly


### TEMPLATES ###

# copy the functions in this section and edit for your needs
# vim substitutions:
# s/myserver/server
# s/myuser/username
# s/myscpdir/remotedir (without slash)

# SSH connection function
function myserver {
if [ "$1" = "-h" -o "$1" = "--help" ]
then
 # show help
 echo "Usage: myserver [OPTION] [command]
Connect via SSH to myserver
If a command is given as an argument, execute it remotely,
otherwise start an ssh session connected to myserver.
Option		GNU long option		Meaning
-h		--help			Show this message
-X					Enable X11 forwarding"
elif [ "$1" = "-X" ]
then
 # enable X11 forwarding
 ssh_connection "myserver" "myuser" "$2" "$1"
else
then
 # execute normal
 ssh_connection "myserver" "myuser" "$1"
fi
}

# SCP push function
function push_myserver {
if [ "$1" = "-h" -o "$1" = "--help" ]
then
 # show help
 echo "Usage: push_myserver [file]
Push file to myserver
Option		GNU long option		Meaning
-h		--help			Show this message"
else
then
 # execute normal
 push_to_server "myserver" "myuser" "myscpdir/$1"
fi
}

# SCP pull function
function pull_myserver {
if [ "$1" = "-h" -o "$1" = "--help" ]
then
 # show help
 echo "Usage: push_myserver [file]
Pull file from myserver
Option		GNU long option		Meaning
-h		--help			Show this message"
else
then
 # execute normal
 pull_from_server "myserver" "myuser" "myscpdir/$1"
fi
}
