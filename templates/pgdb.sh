# pgdb
# Template function for managing a connection to a PostgreSQL database
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

# Source the output of this file in your shell's .*rc file
#
# Accepts the following arguments:
# funcname: the name of the generated function
# database: the PostgreSQL database
# user: the PostgreSQL user
# host: the PostgreSQL host [default localhost]
#
# Declares the following function:
# [FUNCNAME]: connect to the PostgreSQL database
#
# Example:
#     pgdb.sh "database" "user" [FUNCNAME]
#
# See README.md for more info


if [ -z "$1" -o -z "$2" ]
then
 printf "Usage: pgdb.sh database user [FUNCNAME]
Output code for function to connect to a database.
[FUNCNAME] defaults to [database].
* [FUNCNAME]: access the PostgreSQL database [database] as [user].
" >&2
 exit 1
fi

### TEMPLATE ###

NAME="$1"
DATABASE="$2"
USER="$3"
if [ -z "$4" ]
then HOST="localhost"
else HOST="$4"
fi

cat << TEMPLATE
# Database access function
$NAME () {
local file
local argc=1
local argv
local option
local state
local good="good"
for arg in "\$@"
do
 if [ "\$state" = "file" ]
 then
  if [ -e "\$arg" ]
  then
   file+=( '-f' "\$arg" )
   argv+=( '-v' "0=\$arg" )
   state="args"
  else
   echo "Cannot find file: \$arg"
   good="bad"
  fi
 elif [ "\$state" = "args" ]
 then
  argv+=( '-v' "\$argc=\$arg" )
  argc=\$(expr $argc + 1)
 elif [ "\$arg" = "-h" -o "\$arg" = "--help" ]
 then
  # show help
  echo "Usage: $NAME [OPTION] [INPUTFILE] [ARGUMENTS...]
Access $DATABASE as $USER.
If a file is given as an argument, execute the queries in the file,
otherwise start a psql session connected to $DATABASE.
Option		GNU long option		Meaning
-h		--help			Show this message
-*		--*			Pass argument to psql (see man psql)"
  return 0
 elif [ "\$arg" = "--" ]
 then
  state="file"
 elif [[ "\$arg" = -* ]]
 then
  option=( "\$arg" )
 elif [ -e "\$arg" ]
 then
  file+=( '-f' "\$arg" )
  argv+=( '-v' "0=\$arg" )
  state="args"
 else
  echo "Cannot find file: \$arg"
  good="bad"
 fi
done

if [ "\$good" != "good" ]
then
 echo "Abort"
 return 1
fi


if [ "\${#file[@]}" = 0 -a "\${#option[@]}" = 0 ]
then
 psql -U "$USER" -h "$HOST" -d "$DATABASE"
elif [ "\${#file[@]}" = 0 ]
then
 psql -U "$USER" -h "$HOST" -d "$DATABASE" "\${option[@]}"
elif [ "\${#option[@]}" = 0 ]
then
 psql -U "$USER" -h "$HOST" -d "$DATABASE" "\${argv[@]}" "\${file[@]}"
else
 psql -U "$USER" -h "$HOST" -d "$DATABASE" "\${argv[@]}" "\${file[@]}" "\${option[@]}"
fi
}
TEMPLATE
