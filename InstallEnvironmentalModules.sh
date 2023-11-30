#!/usr/bin/bash

#both headnodes and worknodes. Ps: commands at the time do this.

#Install the environment-modules package:
dnf -y install environment-modules

#You may have to log in again to execute the module command after installing it.
#The above install creates a few modules in /usr/share/Modules/modulefiles. They can be helpful to look at.
#To see the modules available, execute the following command:
##module avail

cat > /etc/profile.d/zhpc.sh <<EOF
#!/bin/bash
export MODULEPATH=\$MODULEPATH:/soft/modules
EOF

#Now create the same file for the C-Shell:
cat > /etc/profile.d/zhpc.csh <<EOF
#!/bin/csh
setenv MODULEPATH "\$MODULEPATH:/soft/modules"
EOF
chmod 0755 /etc/profile.d/zhpc.{sh,csh}

#create a file
sudo vi /usr/share/Modules/modulefiles/hpc

cat >> /usr/share/Modules/modulefiles/hpc <<EOF
#%Module 1.0
#
# HPC module for use with the 'environment-modules' package:
set SOFT /soft
set MODULES $SOFT/modules
set username $::env(USER)
set tmp_scratch /scratch/$username
if {[info exists env(PBS_JOBNAME)]} {
set scratch $tmp_scratch/$env(PBS_JOBID).$env(PBS_JOBNAME)
} else {
set scratch $tmp_scratch
}
setenv HPC_SOFT $SOFT
setenv HPC_MODULE_PATH $MODULES
setenv HPC_TMP /tmp
setenv HPC_SCRATCH $scratch
setenv HPC_OWNER root
setenv HPC_GROUP hpcuser
setenv TERM linux
prepend-path MODULEPATH $MODULES
prepend-path PATH $SOFT/hpc
append-path INCLUDE /usr/include
append-path LD_LIBRARY_PATH /usr/lib64
append-path PKG_CONFIG_PATH /usr/lib64/pkgconfig
set-alias vi "/usr/bin/vim"
EOF

cat > /etc/profile.d/zmodules_hpc.sh <<EOF
module load hpc
EOF

