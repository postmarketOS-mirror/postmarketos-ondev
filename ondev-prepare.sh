#!/bin/sh -ex
# Copyright 2020 Oliver Smith
# SPDX-License-Identifier: GPL-3.0-or-later

# This script runs during "postmarketos install --ondev", so the
# postmarketos-ondev package can do the following, independent of pmbootstrap
# code:
# * store the channel properties somewhere to display them
# * transform rootfs.img
# * patch configs (e.g. /etc/fstab)
#   NOTE: we don't do this in .post-install, because then it would alter the
#   configs, even if a user installed postmarketos-ondev by accident.

write_welcomeq_pmos_config() {
	# Version: "edge", "v20.05", ...
	version="$channel"
	if [ "$channel" != "edge" ]; then
		version="$channel_branch_pmaports"
	fi

	cat <<- EOF > /etc/calamares/modules/welcomeq-pmos.qml
	---
	arch: "$deviceinfo_arch"
	device: "$deviceinfo_name"
	userInterface: "$user_interface"
	version: "$version"
	EOF
}

if [ "$#" -lt 5 ]; then
	echo "ERROR: do not run this script manually."
	echo "It's only meant to be called during 'pmbootstrap install --ondev'"
	exit 1
fi

. /etc/deviceinfo

channel="$1"
channel_description="$2"
channel_branch_pmaports="$3"
channel_branch_aports="$4"
channel_mirrordir_alpine="$5"
user_interface="$6"

set -x
write_welcomeq_pmos_config

# Adjust root partition label in /etc/fstab, so OpenRC can correctly remount it
# as RW during boot
sed -i s/pmOS_root/pmOS_install/ /etc/fstab

# Disable device-specific services, that are not useful during the installation
# eg25: increases shutdown time by 30s (pinephone modem)
services="
	eg25
"
for service in $services; do
	if [ -e "/etc/init.d/$service" ]; then
		rc-update delete "$service" default
	fi
done
