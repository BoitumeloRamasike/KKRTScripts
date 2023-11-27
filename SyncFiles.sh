#!/usr/bin/bash

#Sync the /etc/{passwd,hosts,group,shadow,sudoers} files
NumberOfNodes=2
for i in $(seq 1 $NumberOfNodes); do
 scp /etc/{passwd,shadow,group,sudoers,hosts} wn0$i:/etc/
done
