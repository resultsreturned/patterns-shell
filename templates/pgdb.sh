# pgdb templates
# Template functions for managing a connection to a PostgreSQL database
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

# Source ../scripts/pgdb.sh in your shell's .*rc file
# Then use template-mydb and template-mydbbackup
# to create your functions
# See README.md for more info


### TEMPLATES ###

# output function definition
# to access a database
# ex.
# source <(template-db "mydb" "myuser" "myfunc")
# * myfunc [OPTION] [queryfile]
# self documenting (-h)
function template-db {

local MYDB=$1
local MYUSER=$2
if [ "$3" ]
then
 local MYFUNC=$3
else
 local MYFUNC=$MYDB
fi

cat << TEMPLATE
# $MYDB access function
function $MYFUNC {
if [ "\$1" = "-h" ]
then
 # show help
 echo "Usage: $MYFUNC [OPTION] [queryfile]
Access $MYDB.
If a file is given as an argument, execute the queries in the file,
otherwise start a psql session connected to $MYDB. 
Option		GNU long option		Meaning
-t		--time			Time the query or session
-h		--help			Show this message"
elif [ -z "\$2" ]
then
 pgdb "$MYDB" "$MYUSER" \$1
else
 # execute with option
 pgdb "$MYDB" "$MYUSER" \$2 \$1
fi
}

TEMPLATE
} # function template-mydb


# output function definition
# to backup a database
# ex.
# source <(template-dbbackup "mydb" "mysuperuser" "mybackupdir" "myfunc")
# * myfunc [OPTION] [file]
# self documenting (-h)
function template-dbbackup {

local MYDB=$1
local MYSUPERUSER=$2
local MYBACKUPDIR=$3
if [ "$3" ]
then
 local MYFUNC=$3
else
 local MYFUNC=${MYDB}backup
fi

cat << TEMPLATE
# $MYDB backup function
function $MYFUNC {
if [ -z "\$1" ]
then
 dated_backup_db "$MYSUPERUSER" "$MYBACKUPDIR/${MYDB}_"
elif [ "\$1" = "-h" ]
then
 echo "Usage: $MYFUNC [OPTION] [file]
Backup or restore $MYDB.
If no arguments given, make dated backup in $MYBACKUPDIR,
otherwise, execute according the options below.
Option		GNU long option		Meaning
-b		--backup		Backup $MYDB to file
-r		--restore		Restore $MYDB from file
-h		--help			Show this message"
elif [ "\$1" = "-b" -a "\$2" ]
then
 backup_db "$MYSUPERUSER" "\$2"
elif [ "\$1" = "-r" -a -e "\$2" ]
then
 restore_db "$MYSUPERUSER" "\$2"
fi
}

TEMPLATE
} # function template-dbbackup
