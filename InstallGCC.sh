#!/usr/bin/bash
set -e
#Installing GCC

dnf -y install epel-release
dnf -y groupinstall "Development Tools" "Legacy UNIX Compatibility"
dnf -y install \
	 libgcc.i686 cmake fftw-devel glibc-devel.i686 \
	  hwloc-devel hwloc

Install_Version=11.1.0
Install_Destination=/soft/gcc/$Install_Version
cd /tmp
wget http://mirror.ufs.ac.za/gnu/gcc/gcc-11.1.0/gcc-11.1.0.tar.gz


tar -xvf gcc-${Install_Version}.tar.gz
cd gcc-${Install_Version}
./configure \
	--prefix=$Install_Destination \
	--enable-threads \
	 --enable-languages="c,c++,fortran,objc,obj-c++ " \
	  --disable-multilib
make -j && sudo make install
mkdir -p /soft/modules/gcc
cd /soft/modules/gcc
sudo cat > $Install_Version <<EOF
#%Module1.0
## gcc modulefile
##
proc ModulesHelp { } {
 puts stderr "\tAdds GCC C/C++ compilers ($Install_Version) to your
environment."
}
module-whatis "Sets the environment for using GCC C/C++ compilers
($Install_Version)"
set GCC_VERSION $Install_Version
set GCC_DIR $Install_Destination
prepend-path PATH \$GCC_DIR/include
prepend-path PATH \$GCC_DIR/bin
prepend-path MANPATH \$GCC_DIR/man
prepend-path LD_LIBRARY_PATH \$GCC_DIR/lib
prepend-path LD_LIBRARY_PATH \$GCC_DIR/lib64
setenv GCC_VER \$GCC_VERSION
setenv CC \$GCC_DIR/bin/gcc
setenv GCC \$GCC_DIR/bin/gcc
setenv FC \$GCC_DIR/bin/gfortran
setenv F77 \$GCC_DIR/bin/gfortran
setenv F90 \$GCC_DIR/bin/gfortran
#For CFLAGS, see: https://gcc.gnu.org/onlinedocs/gcc/x86-Options.html
setenv CFLAGS "-march=broadwell -m64"
EOF
chown -R :hpcusers $Install_Destination /soft/modules
