# pgdb
# PostgreSQL database macros
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


### EXAMPLE ###

# edit this for your needs
function mydbfunc {
if [ "$1" = "-h" ]
then
 # show help
 echo "Usage: mydbfunc [OPTION] [queryfile]
Access DB.
If a file is given as an argument, execute the queries in the file,
otherwise start a psql session connected to DB.
Option		GNU long option		Meaning
-t		--time			Time the query or session
-h		--help			Show this message"
elif [ -z "$2" ]
then
 # execute normal
 pgdb "mydb" "myuser" $1
else
 # execute with option
 pgdb "mydb" "myuser" $2 $1
fi
}

### END EXAMPLE ###


# generic db function
#
# $1 Database name
# $2 Database user
# $3 Query file
# $4 Option
function pgdb {
if [ "$4" = "-t" ]
then
 # Time execution
 date
 if [ -z "$3" ]
 then
  # Open psql session
  psql -U "$2" "$1"
 else [ -e "$3" ]
  # Execute query file
  cat "$3"
  psql -f "$3" -U "$2" "$1"
 fi
 date
elif [ -z "$3" ]
then
 # Open psql session
 psql -U "$2" "$1"
elif [ -e "$3" ]
then
 # Execute query file
 psql -f "$3" -U "$2" "$1"
fi }