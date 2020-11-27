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
part_boot="$(echo "$part_install" | sed 's/3$/1/')"

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

# Configure tinydm to start i3 as root
sed -i "s/AUTOLOGIN_UID=10000/AUTOLOGIN_UID=0/" /etc/conf.d/tinydm
tinydm-set-session -s /usr/share/xsessions/i3.desktop

# Configure i3 to start calamares
mkdir -p /root/.config/i3
cat << EOF > /root/.config/i3/config
new_window none
workspace_layout tabbed
exec xrdb -merge ~/.Xresources
exec unclutter-xfixes --fork --timeout 1
exec calamares -D8
EOF

# Set environment variables
cat << EOF > /root/.profile
# Use mobile keyboard
export QT_IM_MODULE="qtvirtualkeyboard"
export QT_VIRTUALKEYBOARD_STYLE=Plasma

# Make path to boot partition available, so it can be used in
# shellprocess.conf to let foreign distros overwrite the boot partition after
# successful installation. (For postmarketOS, we'll just keep the boot
# partition from the installer.)
export ONDEV_BOOT_PARTITION="$part_boot"
EOF

# Guess DPI based on screen height (FIXME: postmarketos#15)
cat << EOF > /root/.Xresources
Xft.dpi: $(expr "$deviceinfo_screen_height" "*" 100 / 720)
EOF

# Write partial sshd_config, that will be appended to /mnt/install/etc/ssh/
# sshd_config by the shellprocess job (see shellprocess.conf).
mkdir -p /usr/share/postmarketos-ondev
cat << EOF > /usr/share/postmarketos-ondev/sshd_config

# This installation was done with the postmarketos-ondev installer. The
# default user only has a weak, numeric password, which is needed for the lock-
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

# mobile.conf: set targetDeviceRoot
sed -i "s#^targetDeviceRoot:.*#targetDeviceRoot: \"$part_target\"#g" \
	/etc/calamares/modules/mobile.conf

# Add debug user
if [ -e "/no-debug-user" ]; then
	set +x
	echo "NOTE: not creating debug user, because /no-debug-user exists"
	set -x
else
	set +x
	echo "Creating debug user"
	echo "  username: 'user'"
	echo "  password: 'y'"
	echo
	echo "  Use this for login via serial or SSH over USB (172.16.42.1)"
	echo "  and debugging the installer. Calamares log is written to"
	echo "  '/root/.cache/tinydm.log'."
	echo
	echo "  This debug user will not be created if /no-debug-user"
	echo "  exists in the installation OS. Like this:"
	echo "  'pmbootstrap install --ondev --cp anyfile:/no-debug-user'"
	echo
	set -x
	yes | adduser user -G wheel || true
fi

ondev-boot-mount
rc-service elogind start
rc-service tinydm start

sleep 1
tail -F /root/.cache/tinydm.log
