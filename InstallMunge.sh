#!/usr/bin/bash

#install epel-release
dnf install epel-release

#install munge
dnf -y install munge munge-libs

#Generate a MUNGE key for client authentication
/usr/bin/create-munge-key
chown munge:munge /etc/munge/munge.key
chmod 600 /etc/munge/munge.key

#copy the MUNGE key to your compute node to allow it to authenticate
#create this directory in wn's : /etc/munge
#scp /etc/munge/munge.key wn01:/etc/munge/munge.key
#scp /etc/munge/munge.key wn02:/etc/munge/munge.key

systemctl start munge
systemctl enable munge
systemctl status munge
