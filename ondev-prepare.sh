#!/bin/sh -ex
# Copyright 2020 Oliver Smith
# SPDX-License-Identifier: GPL-3.0-or-later

# This script runs during "postmarketos install --ondev", so the
# postmarketos-ondev package can do the following, independent of pmbootstrap
# code:
# * store the channel properties somewhere to display them
# * transform rootfs.img

channel="$1"
channel_description="$2"
channel_branch_pmaports="$3"
channel_branch_aports="$4"
channel_mirrordir_alpine="$5"

# do nothing for now
exit 0
