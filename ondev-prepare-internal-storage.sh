#!/bin/sh -e
# Copyright 2020 Oliver Smith
# SPDX-License-Identifier: GPL-3.0-or-later

# Sanity check
part_install="$(df -T / | awk '/^\/dev/ {print $1}')"
if [ "$(realpath /dev/disk/by-label/pmOS_install)" != "$part_install" ]; then
	echo "ERROR: ondev-prepare-internal-storage should only be started" \
		" from the pmOS_install partition!"
	exit 1
fi

echo " === ondev-prepare-internal-storage === "
set -x

. /etc/deviceinfo

dev="$deviceinfo_dev_internal_storage"
dev_boot=""
dev_root=""
boot_filesystem="${deviceinfo_boot_filesystem:-ext2}"
boot_part_start="${deviceinfo_boot_part_start:-2048}"
mb_boot="128"

# Create partition table (see pmb.install.partition.partition())
partitions_create() {
	parted -s "$dev" mktable msdos
	parted -s "$dev" mkpart primary "$boot_filesystem" \
		"${boot_part_start}s" "${mb_boot}M"
	parted -s "$dev" mkpart primary "${mb_boot}M" "100%"
	parted -s "$dev" set 1 boot on
	partprobe "$dev"
}

# Try to find the boot and root partitions for 10 seconds
partitions_find() {
	for i in $(seq 1 100); do
		if [ -e "${dev}p1" ] && [ -e "${dev}p2" ]; then
			dev_boot="${dev}p1"
			dev_root="${dev}p2"
			return
		elif [ -e "${dev}1" ] && [ -e "${dev}2" ]; then
			dev_boot="${dev}1"
			dev_root="${dev}2"
			return
		fi
		sleep 0.1
	done
	echo "Failed to find boot and root partition after creating" \
		"partition table (dev: '$dev')"
	exit 1
}

# Format the boot partition (see pmb.install.format.format_and_mount_boot())
boot_format() {
	case "$boot_filesystem" in
		fat16)
			mkfs.fat -F16 -n pmOS_boot "$dev_boot"
			;;
		fat32)
			mkfs.fat -F32 -n pmOS_boot "$dev_boot"
			;;
		ext2)
			mkfs.ext2 -F -q -L pmOS_boot "$dev_boot"
			;;
		*)
			echo "unsupported filesystem: $boot_filesystem"
			exit 1
	esac
}

# Copy the boot partition contents, either from /boot (target OS is
# postmarketOS), or from the boot partition of /var/lib/rootfs.img (target OS
# is foreign OS).
boot_copy() {
	local target_path="/mnt/install-boot"
	local source_path="/boot"

	# ondev-boot-mount may have found a boot partition in rootfs.img and
	# made it available here
	local source_path_img="/mnt/postmarketos-ondev-boot-img"
	if [ -e "$source_path_img" ]; then
		source_path="/mnt/boot"
		mkdir -p "$source_path"
		mount "$source_path_img" "$source_path"
	fi

	mkdir -p "$target_path"
	mount "$dev_boot" "$target_path"
	cp -a -r "$source_path"/* "$target_path"
	umount "$target_path"

	# Umount rootfs.img boot partition
	if [ -e "$source_path_img" ]; then
		umount "$source_path"
	fi
}

# Write firmware binaries from /usr/share to the target device, as defined in
# deviceinfo_sd_embed_firmare. The pmbootstrap code is in
# pmb.install._install.embed_firmware() and has sanity checks, which all must
# pass in order to create the image with the on-device installer. So we don't
# need to check them again here.
embed_firmware() {
	local embed_fw="$deviceinfo_sd_embed_firmware"
	if [ -z "$embed_fw" ]; then
		return
	fi

	local step="${deviceinfo_sd_embed_firmware_step_size:-1024}"

	for i in $(echo "$embed_fw" | tr ',' ' '); do
		local binary="$(echo "$i" | cut -d':' -f 1)"
		local offset="$(echo "$i" | cut -d':' -f 2)"

		dd if="/usr/share/$binary" of="$dev" bs="$step" seek="$offset"
	done
}

root_symlink_create() {
	# ondev-boot configures targetDeviceRootInternal to this path, because
	# it can't predict the full path to the root partition
	ln -sf "$dev_root" /tmp/ondev-internal-storage
}

partitions_create
partitions_find
boot_format
boot_copy
embed_firmware
root_symlink_create
