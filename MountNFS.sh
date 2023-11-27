#!/usr/bin/bash

#Do this only on WN
#in the etc/hosts file, add storage and scratch as tge host names of the headnode

#Installing the NFS utilities is required to be able to mount an NFS volume
dnf -y install nfs-utils

mkdir /scratch /soft
mount scratch:/data/scratch /scratch
mount storage:/data/soft /soft
mount storage:/home /home

#create back up of fstab
[ -e /backup/fstab ]
if [ $? -ne 0 ]; then
	mkdir /backup
	cp -r /etc/fstab /backup
fi

cat >> /etc/fstab <<EOF
scratch:/data/scratch /scratch nfs rw,tcp,noatime 0 0
storage:/data/soft /soft nfs rw,tcp,noatime 0 0
storage:/home /home nfs rw,tcp,noatime 0 0
EOF

#ensure that everything is mounted correctly
mount -a
