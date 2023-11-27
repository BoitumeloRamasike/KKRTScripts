#!/usr/bin/bash
set -e

#sudors: not prompt for password
sed -i "$ a\%wheel ALL=(ALL) NOPASSWD: ALL" /etc/sudoers
