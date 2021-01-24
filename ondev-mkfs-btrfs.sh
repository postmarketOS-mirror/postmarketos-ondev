#!/bin/sh -ex
# Create a snapshotable subvolume for the btrfs root partition

mkfs.btrfs -L "pmOS_root" $@
targetdisk=$(echo "$@" | awk '{ print $NF }')

mkdir -p /subvolume
mount ${targetdisk} /subvolume
btrfs subvolume create /subvolume/root
btrfs subvolume set-default /subvolume/root
umount /subvolume
