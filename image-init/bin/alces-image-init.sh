#!/bin/bash

export alces_image_init=/opt/alces/image-init/
export alces_remote_bucket=http://images.alces-software.com.s3.amazonaws.com/ruan
mkdir -p $alces_image_init
mkdir -p $alces_image_init/etc
mkdir -p $alces_image_init/bin

#Install Alces Clusterware Core
export alces_OS=el6
curl -L "https://raw.githubusercontent.com/alces-software/clusterware/master/scripts/bootstrap" | /bin/bash

