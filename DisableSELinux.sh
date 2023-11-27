#!/usr/bin/bash

#Disable SELinux
sed "s|^SELINUX.*|SELINUX=disabled|g" /etc/selinux/config
echo "Sucessul"
setenforce 0
