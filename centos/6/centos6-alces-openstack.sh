#!/bin/bash
################################################################################
# (c) Copyright 2007-2014 Alces Software Ltd                                   #
#                                                                              #
# Symphony Software Toolkit                                                    #
#                                                                              #
# This file/package is part of Symphony                                        #
#                                                                              #
# Symphony is free software: you can redistribute it and/or modify it under    #
# the terms of the GNU Affero General Public License as published by the Free  #
# Software Foundation, either version 3 of the License, or (at your option)    #
# any later version.                                                           #
#                                                                              #
# Symphony is distributed in the hope that it will be useful, but WITHOUT      #
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or        #
# FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Affero General Public License #
# for more details.                                                            #
#                                                                              #
# You should have received a copy of the GNU Affero General Public License     #
# along with Symphony.  If not, see <http://www.gnu.org/licenses/>.            #
#                                                                              #
# For more information on the Symphony Toolkit, please visit:                  #
# http://www.alces-software.org/symphony                                       #
#                                                                              #
################################################################################

RED='\033[0;31m'
NC='\033[0m' # No Color
GREEN='\033[0;32m'
PARENTPID=$$

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

trap "/bin/kill -- -$BASHPID &>/dev/null" EXIT INT TERM

LOGDIR="/tmp/alces-imageinit.`date +"%Y%m%d%H%M"`"

function toggle_spin () {
	if [ -z "$spin_pid" ]; then
	    (
		i=1
		sp="/-\|"
		printf " "
		while true;
		do
		    printf "\b[1m${sp:i++%${#sp}:1}[0m"
		    if [[ i -eq ${#sp} ]]; then
			i=0
		    fi
		    sleep 0.2
		done
	    ) &
	    sleep 1
	    spin_pid=$!
	else
	    sleep 1
	    kill $spin_pid
	    wait $spin_pid 2>/dev/null
	    printf "\b"
	    unset spin_pid
	fi
}

function title() {
    printf "\n > $1\n"
}

function doing() {
    if [ -z "$2" ]; then
	pad=12
    else
	pad=$2
    fi
    printf "    [36m%${pad}s[0m ... " "$1"
    toggle_spin
}

function say_done () {
    toggle_spin
    if [ $1 -gt 0 ]; then
	echo '[31mFAIL[0m'
	exit 1
    else
	echo '[32mOK[0m '
    fi
}

#What to call the image in libvirt
if [ -z $IMAGE_NAME ]; then
  IMAGE_NAME=centos6-alces-openstack
fi

#Primary disk size in GB
if [ -z $IMAGE_SIZE ]; then
  IMAGE_SIZE=8
fi

#QCOW2 pool path
if [ -z $POOL_PATH ]; then
  POOL_PATH=/var/lib/libvirt/images
fi

#OZ config file
if [ -z $OZ_CONFIG ]; then
  echo "OZ_CONFIG not set, please set OZ_CONFIG env variable" >&2 
  exit 1
fi

TDL=/tmp/tdl.$$

sed -e "s|%DISKSIZE%|$IMAGE_SIZE|g"  \
    -e "s|%NAME%|$IMAGE_NAME|g" $DIR/centos6-alces-openstack.tdl.template > $TDL
#Install to stage 1 - ready for installing software
title 'Starting Image Build'
doing 'Building qcow2 image'
oz-install -d3 -u $TDL -x $POOL_PATH/$IMAGE_NAME.xml -p -a $DIR/centos6-alces-openstack.auto -c $OZ_CONFIG 1> $LOGDIR 2>&1
say_done $?

title 'Preparing for Configuration'
doing 'Defining in libvirt'
virsh define $POOL_PATH/$IMAGE_NAME.xml 1> $LOGDIR 2>&1
say_done $?
doing 'Booting image'
virsh start $IMAGE_NAME 1> $LOGDIR 2>&1
say_done $?
doing 'Connecting console'
screen -S alces-imageinit.$PARENTPID -d -m virsh console $IMAGE_NAME 1> $LOGDIR 2>&1
say_done $?

printf "
${GREEN}===============================================================================
 Stage 1 is now complete!
===============================================================================${NC}
The image has now been defined in libvirt and there is a console connected in a screen session.
To make any customisations, run the following:

${RED}screen -r alces-imageinit.$$ ${NC}

Run the following to prepare the image for uploading to an Openstack deployment:

${RED}$DIR/../../bin/alces-imageinit-cloudify.sh ${NC}
"
#rm $TDL
