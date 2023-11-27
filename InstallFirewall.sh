#! /usr/bin/bash

set -e

#Install firewall
dnf -y install firewalld

#Enable and restart firewall
systemctl enable firewalld --now

#Declare variables
WAN_INT="enX0" #Specify the WAN interface connected to the Internet
LAN_INT="enX1" #Specify the internal interface

#Modify the connections of the interface(s) to reflect the correct zones:
nmcli con mod $WAN_INT connection.zone external
nmcli con mod $LAN_INT connection.zone internal

#Bring the connections up with the modified zones
nmcli con up $WAN_INT
nmcli con up $LAN_INT

#Add the firewall rules to allow NAT through the public interface
firewall-cmd --permanent --new-policy policy_int_to_ext
firewall-cmd --permanent --policy policy_int_to_ext --add-ingress-zone internal
firewall-cmd --permanent --policy policy_int_to_ext --add-egress-zone external
firewall-cmd --permanent --policy policy_int_to_ext --set-priority 100
firewall-cmd --permanent --policy policy_int_to_ext --set-target ACCEPT
firewall-cmd --permanent --zone=external --add-masquerade
firewall-cmd --reload

#Display some information:
firewall-cmd --get-active-zones
firewall-cmd --list-all --zone=external

#Restart firewall
systemctl restart firewalld
