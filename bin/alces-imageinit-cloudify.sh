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

if [ -z $1 ]; then
  echo "Please specify image name" >&2
  exit 1
fi

export IMAGE_NAME=$1

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
if [ -z $POOL_PATH ]; then
  . $DIR/../etc/vars
else
  echo "Skip loading config"
fi

export OZ_CONFIG=/tmp/oz.cfg.$$

echo "Prepare.."
sed -e "s|%POOL_PATH%|$POOL_PATH|g" \
	-e "s/%EXT_BRIDGE%/$EXT_BRIDGE/g" $DIR/../config/oz.cfg.template > $OZ_CONFIG

printf "
${GREEN}===============================================================================
 Starting Image Cloudify
===============================================================================${NC}
"


$DIR/../centos/6/centos6-alces-openstack-stage2.sh


echo "Cleanup.."
rm $OZ_CONFIG
