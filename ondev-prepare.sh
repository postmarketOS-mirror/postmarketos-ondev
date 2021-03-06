#!/bin/sh -ex
# Copyright 2020 Oliver Smith
# SPDX-License-Identifier: GPL-3.0-or-later

# This script runs during "postmarketos install --ondev", so the
# postmarketos-ondev package can do the following, independent of pmbootstrap
# code:
# * store the channel properties somewhere to display them
# * transform rootfs.img (in theory, not doing that yet)
# * patch configs (e.g. /etc/fstab)
#   NOTE: we don't do this in .post-install, because then it would alter the
#   configs, even if a user installed postmarketos-ondev by accident.

. /etc/deviceinfo

# Variables passed from pmbootstrap install
: ${ONDEV_CHANNEL:="edge"}
: ${ONDEV_CHANNEL_BRANCH_APORTS:="3.12-stable"}
: ${ONDEV_CHANNEL_BRANCH_PMAPORTS:="v20.05"}
: ${ONDEV_CHANNEL_DESCRIPTION:="Some channel description here"}
: ${ONDEV_CHANNEL_MIRRORDIR_ALPINE:="v3.12"}
: ${ONDEV_CIPHER:=""}
: ${ONDEV_PMBOOTSTRAP_VERSION:="0.0.0"}
: ${ONDEV_UI:="plasma-mobile"}
: ${ONDEV_DISTRO:="postmarketOS"}

# Minimum required pmbootstrap version check
check_pmbootstrap_version() {
	min="1.20.0"

	if [ "$ONDEV_PMBOOTSTRAP_VERSION" = "0.0.0" ]; then
		echo "ERROR: do not run this script manually."
		echo "It's only meant to be called during" \
			"'pmbootstrap install --ondev'"
		exit 1
	fi

	version_result="$(apk version -t "$ONDEV_PMBOOTSTRAP_VERSION" "$min")"
	if [ "$version_result" = "=" ] || [ "$version_result" = ">" ]; then
		# Version check passed
		return
	elif [ "$version_result" = "<" ]; then
		echo "ERROR: this version of postmarketos-ondev requires" \
			"pmbootstrap version $min or higher. You are using" \
			"pmbootstrap version $ONDEV_PMBOOTSTRAP_VERSION."
	else
		echo "ERROR: failed to verify pmbootstrap version"
	fi
	exit 1
}

pretty_ui() {
	# Translate the UI value from "pmbootstrap config ui", which is the
	# suffix of the postmarketos-ui-* pkgnames, to the pretty name if
	# possible.
	case "$1" in
		gnome) echo "GNOME" ;;
		i3wm) echo "i3" ;;
		kodi) echo "Kodi" ;;
		mate) echo "MATE" ;;
		phosh) echo "Phosh" ;;
		plasma-bigscreen) echo "Plasma Bigscreen" ;;
		plasma-desktop) echo "Plasma Desktop" ;;
		plasma-mobile*) echo "Plasma Mobile" ;;
		shelli) echo "Shelli" ;;
		sway) echo "Sway" ;;
		sxmo) echo "Sxmo" ;;
		weston) echo "Weston" ;;
		xfce4) echo "XFCE4" ;;
		*) echo "$1" ;;
	esac
    }

# Write /etc/calamares/modules/mobile.conf, based on data from deviceinfo and
# what pmbootstrap passed.
write_calamares_mobile_config() {
	# Version: "edge", "v20.05", ...
	version="$ONDEV_CHANNEL"
	if [ "$ONDEV_CHANNEL" != "edge" ]; then
		version="$ONDEV_CHANNEL_BRANCH_PMAPORTS"
	fi

	cipher_arg=""
	if [ -n "$ONDEV_CIPHER" ]; then
		cipher_arg="--cipher '$ONDEV_CIPHER'"
	fi

	cat <<- EOF > /etc/calamares/modules/mobile.conf
	---
	osName: "postmarketOS"
	arch: "$deviceinfo_arch"
	device: "$deviceinfo_name"
	userInterface: "$(pretty_ui "$ONDEV_UI")"
	version: "$version"

	cmdLuksFormat: "cryptsetup luksFormat --use-random $cipher_arg"
	cmdMkfsRootExt4: "mkfs.ext4 -O '^metadata_csum,^huge_file' -L 'pmOS_root'"
	cmdInternalStoragePrepare: "ondev-prepare-internal-storage"

	cmdSshdEnable: "rc-update add sshd default"
	# Don't fail if already disabled (ondev#40)
	cmdSshdDisable: "rc-update del sshd default || true"

	# Placeholder to be filled in by ondev-boot.sh
	targetDeviceRoot: "/dev/unknown"
	targetDeviceRootInternal: ""
	EOF
}

# Disable device-specific services, that are not useful during the installation
# eg25: increases shutdown time by 30s (pinephone modem)
disable_services() {
	services="
		eg25
	"
	for service in $services; do
		if [ -e "/etc/init.d/$service" ]; then
			rc-update delete "$service" default
		fi
	done
}

set -x
check_pmbootstrap_version
write_calamares_mobile_config
disable_services
