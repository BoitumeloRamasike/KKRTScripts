#!/usr/bin/bash

cat > /etc/security/limits..conf <<-EOF
* hard memlock unlimited
* soft memlock unlimited
* soft nofile 63488
* hard nofile 63488
EOF

ulimit -a

ProfileName=hpc-performance
Vendor=$(lscpu |grep "^Vendor ID" | sed -e "s|.*: *||g.*: *||g")

dnf -y install tuned
systemctl enable tuned --now
if [ "$Vendor" == "GenuineIntel" ]; then
	 grep "intel_pstate" /etc/default/grub > /dev/null
	  result=$?
	 
  if [ $result -ne 0 ]; then
    sed -i "/^GRUB_CMDLINE_LINUX=/ s|\"$| intel_pstate=disable\"|g" \ /etc/default/grub
	grub2-mkconfig -o /boot/grub2/grub.cfg
  fi
  cat /proc/cmdline |grep "intel_pstate=disable" > /dev/null
fi

cd /usr/lib/tuned/

[ -e $ProfileName ] || mkdir -p $ProfileName
cd $ProfileName
cat > tuned.conf <<EOF
[main]
summary=Optimize for deterministic performance; increased power consumption
include=throughput-performance

[sysctl]
vm.overcommit_memory = 11
EOF

tuned-adm profile $ProfileName
tuned-adm active
