#!/usr/bin/bash

#All the system users should execute the following commands to allow them to connect password-less to the nodes:
Dir="$HOME/.ssh"
Type=ed25519
if ! [ -e $Dir/id_${Type} ]; then
 ssh-keygen -t $Type -N '' -f $Dir/id_${Type}
 cat $Dir/id_${Type}.pub >> $Dir/authorized_keys
 chmod 600 $Dir/authorized_keys
fi
