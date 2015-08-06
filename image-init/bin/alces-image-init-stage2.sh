#!/bin/bash
export alces_image_init=/opt/alces/image-init/
export alces_remote_bucket=http://images.alces-software.com.s3.amazonaws.com/ruan

yum -y install cloud-utils cloud-init growpart

#Grab cloud.cfg - eventually pull tarball
curl $alces_remote_bucket/cloud.cfg -o $alces_image_init/etc/cloud.cfg
cp $alces_image_init/etc/cloud.cfg /etc/cloud/cloud.cfg

#Install rootfs-resize
cd /opt ; git clone https://github.com/flegmatik/linux-rootfs-resize.git ; cd linux-rootfs-resize ; ./install

#Grab clean_image binary & execute
curl -L $alces_remote_bucket/image_clean.sh | /bin/bash
