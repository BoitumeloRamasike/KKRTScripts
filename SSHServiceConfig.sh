#!/usr/bin/bash

sed "s|^PermitRootLogin.*|PermitRootLogin prohibit-password|g; s|^UseDNS.*|UseDNS no|g" /etc/ssh/sshd_config
if [ $? -ne 0 ]; then
	echo "Error:setting (sed) was unsuccessful"
	exit 1
fi
systemctl restart sshd
echo "SSH config updated sucessful."
