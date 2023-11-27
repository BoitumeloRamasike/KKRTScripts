#!/usr/bin/bash

set -e

#The following line reads: test if a specific file exists or else execute: ssh-keygen -t ed25519
[ -e ~/.ssh/id_ed25519 ] || ssh-keygen -t ed25519 -N '' -f ~/.ssh/id_ed25519

cd ~/.ssh
cat id_ed25519.pub >> authorized_keys
chmod 600 authorized_keys

# Let's try and copy root's existing SSH key to the nodes:
nodes=4 #It is important to set this only to the number of worker nodes
err_code=0
for i in $(seq 1 $nodes); do
 ssh-copy-id -i ~/.ssh/id_ed25519 root@wn0${i}
 err_code=$(( $err_code + $? ))
done
if [ $err_code -ne 0 ]; then

 #ONLY IF THE ABOVE FAILED is it necessary to perform the rest of this code-block
 # Now, we need to copy this key to nodes, but root can't ssh/scp to the nodes yet
 # So, we copy the authorized_keys file to the remote hosts as a normal user first:
 MyUsername=adelaide
 MyHome=$(eval echo ~$MyUsername)
 nodes=4
 for i in $(seq 1 $nodes); do
 ssh-copy-id -i ~/.ssh/id_ed25519 ${MyUsername}@wn0${i}
 done
 
 # The following for loop is a bit complex, but in essence, for each node:
 # log in as our regular user, create /root/.ssh and append the content of
 # the normal user’s authorized_keys file to root’s authorized_keys file:
 for i in $(seq 1 $nodes); do
 ssh -n ${MyUsername}@wn0${i} "sudo mkdir /root/.ssh &>/dev/null; \
 sudo bash -c 'cat $MyHome/.ssh/authorized_keys >> \
 /root/.ssh/authorized_keys'"
 done

 # After the authorized_keys files were copied, we should be able to log into
 # the remote nodes as root without being prompted for a password, let's test it:
 for i in $(seq 1 $nodes); do
 ssh -n wn0${i} "hostname;uptime;echo;echo"
 done
fi
