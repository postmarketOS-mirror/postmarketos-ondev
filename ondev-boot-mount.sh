#!/bin/sh
# Copyright 2020 Oliver Smith
# SPDX-License-Identifier: GPL-3.0-or-later

msg() {
	echo "ondev-boot-mount: $@"
}

IMAGE="/var/lib/rootfs.img"
MOUNT_ROOT="/mnt/postmarketos-ondev-rootfs"
MOUNT_BOOT="/mnt/postmarketos-ondev-boot-img"

if mountpoint -q "$MOUNT_ROOT"; then
	msg "skipping (already mounted)"
	exit 0
fi

msg "mounting image: $IMAGE"
LOOPDEV="$(losetup -P --show -f "$IMAGE")"
partprobe "$LOOPDEV"

if [ -e "${LOOPDEV}p1" ] && [ -e "${LOOPDEV}p2" ]; then
	msg "found two partitions, assuming p1 is bootfs and p2 is rootfs"

	# Mount rootfs to the location configured for unpackfs
	mkdir -p "$MOUNT_ROOT"
	mount "${LOOPDEV}p2" "$MOUNT_ROOT"

	# Mount boot image to known location, so we can dd it over the
	# installer OS'es boot partition after successful install
	touch "$MOUNT_BOOT"
	mount --bind "${LOOPDEV}p1" "$MOUNT_BOOT"
else
	msg "found no partitions, assuming image is rootfs"

	# Mount rootfs to the location configured for unpackfs
	mkdir -p "$MOUNT_ROOT"
	mount "$LOOPDEV" "$MOUNT_ROOT"
fi
