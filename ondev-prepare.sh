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
: ${ONDEV_CIPHER:="aes-xts-plain64"}
: ${ONDEV_PMBOOTSTRAP_VERSION:="0.0.0"}
: ${ONDEV_UI:="plasma-mobile"}

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

# Write /etc/calamares/modules/mobile.conf, based on data from deviceinfo and
# what pmbootstrap passed.
write_calamares_mobile_config() {
	# Version: "edge", "v20.05", ...
	version="$ONDEV_CHANNEL"
	if [ "$ONDEV_CHANNEL" != "edge" ]; then
		version="$ONDEV_CHANNEL_BRANCH_PMAPORTS"
	fi

	cat <<- EOF > /etc/calamares/modules/mobile.conf
	---
	arch: "$deviceinfo_arch"
	device: "$deviceinfo_name"
	userInterface: "$ONDEV_UI"
	version: "$version"
	EOF
}

# This file isn't parsed by the pmos module. ondev-boot.sh reads it and passes
# the cipher as environment variable.
write_partitionq_config() {
	cat <<- EOF > /etc/calamares/modules/partitionq.conf
	---
	cipher: "$ONDEV_CIPHER"
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
write_partitionq_config
disable_services
