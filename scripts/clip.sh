# clip
# A shortcut function that simplifies usage of xclip
#
# Copyright (C) 2014 Nathan Broadbent, Mara Kim
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
# Source this file in your shell's .*rc file


# A shortcut function that simplifies usage of xclip.
# - Accepts input from either stdin (pipe), or params.
# ------------------------------------------------
cb() {
  local _scs_col="\e[0;32m"; local _wrn_col='\e[1;31m'; local _trn_col='\e[0;33m'
  # Check that xclip is installed.
  if ! type xclip > /dev/null 2>&1; then
    printf "$_wrn_col"'You must have the `xclip` program installed.\e[0m\n'
  # Check user is not root (root doesn't have access to user xorg server)
  elif [[ "$USER" == "root" ]]; then
    printf "$_wrn_col"'Must be regular user (not root) to copy a file to the clipboard.\e[0m\n'
  else
    # If no tty, data should be available on stdin
    if ! [[ "$( tty )" == /dev/* ]]; then
      input="$(< /dev/stdin)"
    # Else, fetch input from params
    else
      input="$*"
    fi
    if [ -z "$input" ]; then  # If no input, print clipboard contents
      xclip -out -selection clipboard
      if [ -t 1 ]; then
        printf '\n'
      fi
    else
      # Copy input to clipboard
      printf '%s' "$input" | xclip -selection c
      # Print status.
      if [ ${#input} -gt 80 ]
      then printf "$_scs_col"'Copied to clipboard:\e[0m %s'"$_trn_col"'...\e[0m\n' "$(head -c80 <<<"$input")"
      else printf "$_scs_col"'Copied to clipboard:\e[0m %s\n' "$input"
      fi
    fi
  fi
}

# Aliases / functions leveraging the cb() function
# ------------------------------------------------
# Copy contents of a file
function cbf() { cat "$@" | cb; }
# Copy SSH public key
alias cbssh="cbf ~/.ssh/id_rsa.pub"
# Copy current working directory
alias cbwd="cb \"$PWD\""
# Copy most recent command in bash history
alias cbhs="fc -ln -1 | cb"
