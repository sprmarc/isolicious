#!/bin/bash

set -e

####################
# definition block #
####################

export dir="/httpboot"

# check for root privilege
if [ "$(id -u)" != "0" ]; then
   echo " this script must be run as root" 1>&2
   echo
   exit 1
fi

# define download function
# courtesy of http://fitnr.com/showing-file-download-progress-using-wget.html
download()
{
    local url=$1
    echo -n "    "
    wget --progress=dot $url 2>&1 | grep --line-buffered "%" | \
        sed -u -e "s,\.,,g" | awk '{printf("\b\b\b\b%4s", $2)}'
    echo -ne "\b\b\b\b"
    echo " DONE"
}

#####################
# operational block #
#####################

# update repos
apt-get -y update

# create directory where the custom image will be stored
mkdir -p $dir

# Allow passwordless sudo for members of group sudo

###################
# finishing block #
###################

unset dir
