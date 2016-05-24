#!/bin/bash
set -e

dir="/httpboot"
image="trusty.qcow2"


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

# update repos
apt-get -y update
apt-get -y upgrade
apt-get -y dist-upgrade
apt-get -y autoremove
apt-get -y purge

# create directory where the custom image will be stored
mkdir -p $dir

# download the custom trusty image if it doesn't yest exist
if [[ ! -f $dir/$image ]]; then
	echo -n " downloading image..."
        cd $dir
        download "https://raw.githubusercontent.com/sprmarc/isolicious/master/$image"
fi

# remove myself to prevent any unintended changes at a later stage
rm $0

# finish
echo " DONE; rebooting ... "

# reboot
reboot
