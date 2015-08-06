OLD_VERSION=$1
NEW_VERSION=$2

if [ -z "$NEW_VERSION" ]; then
  exit 1
fi

if [ -z "$OLD_VERSION" ]; then
  exit 1
fi

POOL_DIR=/opt/vm

virt-clone -o symphony-director-$OLD_VERSION -n symphony-director-$NEW_VERSION -f $POOL_DIR/symphony-director-$NEW_VERSION.qcow2 --force --replace
virt-sysprep --enable abrt-data,bash-history,blkid-tab,crash-data,cron-spool,dhcp-client-state,dovecot-data,firstboot,logfiles,lvm-uuids,machine-id,mail-spool,net-hostname,net-hwaddr,pacct-log,package-manager-cache,pam-data,random-seed,rhn-systemid,rpm-db,samba-db-log,script,smolt-uuid,ssh-hostkeys,sssd-db-log,udev-persistent-net,utmp,yum-uuid --domain symphony-director-$NEW_VERSION
virt-clone -o symphony-monitor-$OLD_VERSION -n symphony-monitor-$NEW_VERSION -f $POOL_DIR/symphony-monitor-$NEW_VERSION.qcow2 --force --replace
virt-sysprep --enable abrt-data,bash-history,blkid-tab,crash-data,cron-spool,dhcp-client-state,dovecot-data,firstboot,logfiles,lvm-uuids,machine-id,mail-spool,net-hostname,net-hwaddr,pacct-log,package-manager-cache,pam-data,random-seed,rhn-systemid,rpm-db,samba-db-log,script,smolt-uuid,ssh-hostkeys,sssd-db-log,udev-persistent-net,utmp,yum-uuid --domain symphony-monitor-$NEW_VERSION
virt-clone -o symphony-repo-$OLD_VERSION -n symphony-repo-$NEW_VERSION -f $POOL_DIR/symphony-repo-$NEW_VERSION.qcow2 -f $POOL_DIR/symphony-repo-$NEW_VERSION-pulp.qcow2 -f $POOL_DIR/symphony-repo-$NEW_VERSION-mongo.qcow2 --force --replace
virt-sysprep --enable abrt-data,bash-history,blkid-tab,crash-data,cron-spool,dhcp-client-state,dovecot-data,firstboot,logfiles,lvm-uuids,machine-id,mail-spool,net-hostname,net-hwaddr,pacct-log,package-manager-cache,pam-data,random-seed,rhn-systemid,rpm-db,samba-db-log,script,smolt-uuid,ssh-hostkeys,sssd-db-log,udev-persistent-net,utmp,yum-uuid --domain symphony-repo-$NEW_VERSION
virt-clone -o symphony-app-$OLD_VERSION -n symphony-app-$NEW_VERSION -f $POOL_DIR/symphony-app-$NEW_VERSION.qcow2 --force --replace
virt-sysprep --enable abrt-data,bash-history,blkid-tab,crash-data,cron-spool,dhcp-client-state,dovecot-data,firstboot,logfiles,lvm-uuids,machine-id,mail-spool,net-hostname,net-hwaddr,pacct-log,package-manager-cache,pam-data,random-seed,rhn-systemid,rpm-db,samba-db-log,script,smolt-uuid,ssh-hostkeys,sssd-db-log,udev-persistent-net,utmp,yum-uuid --domain symphony-app-$NEW_VERSION
virt-clone -o symphony-directory-$OLD_VERSION -n symphony-directory-$NEW_VERSION -f $POOL_DIR/symphony-directory-$NEW_VERSION.qcow2 --force --replace
virt-sysprep --enable abrt-data,bash-history,blkid-tab,crash-data,cron-spool,dhcp-client-state,dovecot-data,firstboot,logfiles,lvm-uuids,machine-id,mail-spool,net-hostname,net-hwaddr,pacct-log,package-manager-cache,pam-data,random-seed,rhn-systemid,rpm-db,samba-db-log,script,smolt-uuid,ssh-hostkeys,sssd-db-log,udev-persistent-net,utmp,yum-uuid --domain symphony-directory-$NEW_VERSION
