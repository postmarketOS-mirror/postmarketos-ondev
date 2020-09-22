#!/bin/sh -ex
# Copyright 2020 Oliver Smith
# SPDX-License-Identifier: GPL-3.0-or-later

# This script runs as soon as the rootfs generated by
# "postmarketos install --ondev" boots up.

# Find the target partition
# ---
# In the future, it should be possible to select the target device and
# partition from the installer. Then it would be possible to install
# postmarketOS from the SD card to the internal storage. There is no QML UI in
# Calamares yet for this, so let's simply install into the "reserved space"
# that "pmbootstrap install --ondev" creates on the same device:
# - p1: boot partition
# - p2: reserved space (target partition)
# - p3: install partition (mounted as /)
part_install="$(df -T / | awk '/^\/dev/ {print $1}')"
part_target="$(echo "$part_install" | sed 's/3$/2/')"

# Sanity check
if [ "$(realpath /dev/disk/by-label/pmOS_install)" != "$part_install" ]; then
	if [ -n "$ONDEV_SKIP_LABEL_CHECK" ]; then
		echo "WARNING: not booting from pmOS_install, but" \
			"ONDEV_SKIP_LABEL_CHECK is set."
	else
		echo "ERROR: ondev-boot should only be started from the" \
			"pmOS_install partition!"
		exit 1
	fi
fi

. /etc/deviceinfo

# Calamares module "unpackfs" needs loop
modprobe loop || true

# Configure lightdm to start i3
mkdir -p /usr/share/lightdm/lightdm.conf.d
cat << EOF > /usr/share/lightdm/lightdm.conf.d/00-autologin.conf
[Seat:*]
autologin-user=root
autologin-user-timeout=0
autologin-session=i3
EOF

# Configure i3 to start calamares
mkdir -p /root/.config/i3
cat << EOF > /root/.config/i3/config
new_window none
workspace_layout tabbed
exec unclutter-xfixes --fork --timeout 1
exec calamares
EOF

# Set environment variables
cat << EOF > /root/.profile
# Used by partitionq in calamares
export ONDEV_PARTITION_TARGET="$part_target"  # used by "partitionq"
export QT_IM_MODULE="qtvirtualkeyboard"
export QT_VIRTUALKEYBOARD_STYLE=Plasma
EOF

# Guess DPI based on screen height (FIXME: postmarketos#15)
cat << EOF > /root/.Xresources
Xft.dpi: $(expr "$deviceinfo_screen_height" "*" 100 / 720)
EOF

# Write partial sshd_config, that will be appended to /mnt/install/etc/ssh/
# sshd_config by the shellprocess job (see shellprocess.cfg).
mkdir -p /usr/share/postmarketos-ondev
cat << EOF > /usr/share/postmarketos-ondev/sshd_config

# This installation of postmarketOS was done with the on-device installer. The
# user "user" only has a weak, numeric password, which is needed for the lock-
# screens of Phosh and Plasma Mobile. This weak password is not suitable for
# logging in via SSH, therefore disable password authentication below.
# During the installation, we have asked if a dedicated SSH user should be
# added to the system, with a strong password and freely chosen username.
# Password authentication is not disabled for this user, however we strongly
# encourage you to set up an SSH key and disable password authentication for
# that SSH user as well: https://postmarketos.org/ssh
Match User user
    PasswordAuthentication no
Match all
EOF

# DEBUG: add user for ssh (password: 'y')
# yes | adduser user -G wheel || true

# Configure cryptsetup cipher
# FIXME: properly use config in partitionq, instead of ONDEV_CIPHER and
# ONDEV_PARTITION_TARGET environment variables
ONDEV_CIPHER="$(cat /etc/calamares/modules/partitionq.conf | grep "^cipher:" | cut -d '"' -f 2)"
echo "export ONDEV_CIPHER='$ONDEV_CIPHER'" >> /root/.profile

rc-service lightdm start
