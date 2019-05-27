#!/bin/bash

# Stop on the first sign of trouble
set -e

if [ $UID != 0 ]; then
    echo "ERROR: Operation not permitted. Forgot sudo?"
    exit 1
fi

SCRIPT_DIR=$(pwd)

VERSION="master"
if [[ $1 != "" ]]; then VERSION=$1; fi

echo "The Things Network Gateway installer"
echo "Version $VERSION"


# Change hostname if needed
CURRENT_HOSTNAME=$(hostname)


# Check dependencies
echo "Installing dependencies..."
apt-get install git libi2c-dev minicom dialog ppp -y
rak_pppd/ppp-creator.sh HOLOGRAM ttyAMA0


# add config "dtoverlay=pi3-disable-bt" to config.txt
linenum=`sed -n '/dtoverlay=pi3-disable-bt/=' /boot/config.txt`
if [ ! -n "$linenum" ]; then
	echo "dtoverlay=pi3-disable-bt" >> /boot/config.txt
fi


# add cmd "systemctl stop serial-getty@ttyAMA0.service" to rc.local
linenum=`sed -n '/serial-getty@ttyAMA0.service/=' /etc/rc.local`
if [ ! -n "$linenum" ]; then
	set -a line_array
	line_index=0
	for linenum in `sed -n '/exit 0/=' /etc/rc.local`; do line_array[line_index]=$linenum; let line_index=line_index+1; done
	sed -i "${line_array[${#line_array[*]} - 1]}isystemctl stop serial-getty@ttyAMA0.service" /etc/rc.local
fi

# add rak_script to rc.local
linenum=`sed -n '/rak_script/=' /etc/rc.local`
if [ ! -n "$linenum" ]; then
	set -a line_array
	line_index=0
	for linenum in `sed -n '/exit 0/=' /etc/rc.local`; do line_array[line_index]=$linenum; let line_index=line_index+1; done
	sed -i "${line_array[${#line_array[*]} - 1]}i/usr/local/rak/bin/rak_script" /etc/rc.local
fi

systemctl disable hciuart
cd $SCRIPT_DIR
cp gateway-config /usr/bin/gateway-config
cp config.txt /boot/config.txt


