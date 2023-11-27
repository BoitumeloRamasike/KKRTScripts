#!/usr/bin/bash

set -e

#Execute the following on the HN
#The following can be executed to set a hostname correctly for the HN and all WNs:
Domain_name=examplesdomain.local
NumberOfNodes=2
sudo hostnamectl set-hostname hn.${Domain_name}
for i in $(seq 1 $NumberOfNodes); do
 ssh -n wn0$i "sudo hostnamectl set-hostname wn0${i}.${Domain_name}"
done

#This is only run on the head node or storage node
#Remember, we are assuming /data is already created/mounted
cd /data

#Make sure that you are on the correct path and see the data expected in this volume
ls

#Create the scratch and soft directories
mkdir scratch soft

#Create the symbolic links:
ln -s /data/soft /
ln -s /data/scratch /

#Install the NFS utilities, which are required later
dnf -y install nfs-utils

#Add firewall rules to allow NFS traffic from WNs:
firewall-cmd --permanent --zone=internal --add-service=nfs
firewall-cmd --permanent --zone=internal --add-service=mountd
firewall-cmd --permanent --zone=internal --add-service=rpc-bind

#Activate the rules
firewall-cmd --reload

#List all the services active:
firewall-cmd --permanent --list-all | grep services

cat > /etc/exports <<-eof
/home 10.2.0.100/24(async,rw,no_root_squash,no_subtree_check)
/data/soft 10.2.0.100/24(async,rw,no_root_squash,no_subtree_check)
/data/scratch 10.2.0.200/24(async,rw,no_root_squash,no_subtree_check)
eof

systemctl restart rpcbind
systemctl restart nfs-server
systemctl enable rpcbind
systemctl enable nfs-server
