#!/bin/sh -e

# Configuration
: ${DISTRO:="YourDistroNameHere"}
: ${DISTRO_ROOTFS:="/path/to/ext4rootfs.img"}
: ${DEVICE:="pine64-pinephone"}
: ${CALAMARES_EXT_REPO:="https://github.com/ollieparanoid/calamares-extensions.git"}
: ${CALAMARES_EXT_REV:="calamares-mobile"}
: ${PMBOOTSTRAP_REPO:="https://gitlab.com/postmarketOS/pmbootstrap.git"}
: ${PMBOOTSTRAP_REV:="HEAD"}
: ${PMAPORTS_REPO:="https://gitlab.com/ollieparanoid/pmaports.git"}
: ${PMAPORTS_REV:="calamares-mobile"}

# Clone a repo and checkout a branch, or clean it if it was cloned already.
# Assumes to run in $CACHEDIR.
# $1: dir name
# $2: repository URL
# $3: revision for checkout
clone_repo() {
	local dirname="$1"
	local repo="$2"
	local rev="$3"

	if [ -d "$dirname" ]; then
		echo "_cache/$dirname: git clean (already cloned)"
		git -C "$dirname" clean -f -q
	else
		echo "_cache/$dirname: git clone $repo"
		git clone -q "$repo"

		echo "_cache/$dirname: git checkout $rev"
		git -C "$dirname" checkout -q "$rev"
	fi
}

pmbootstrap() {
	echo "pmbootstrap $@"
	"$CACHEDIR/pmbootstrap/pmbootstrap.py" \
		--aports "$CACHEDIR/pmaports" \
		--config "$TEMPDIR/pmbootstrap.cfg" \
		--log "$TEMPDIR/log.txt" \
		--quiet \
		--work "$CACHEDIR/pmbootstrap-work-dir" \
		"$@"
}

pmbootstrap_init() {
	echo "pmbootstrap init"
	# Don't display questions asked during init
	yes "" | pmbootstrap init >/dev/null
}

find_device_pmaport() {
	local ret

	ret="$(find "$CACHEDIR/pmaports/device" -name "device-$DEVICE")"
	if [ -z "$ret" ]; then
		echo "ERROR: could not find device-$DEVICE in _cache/pmaports/device. Invalid DEVICE set?" >&2
		exit 1
	fi
	echo "$ret"
}

# Prepare dirs
DIR="$(realpath "$(dirname "$0")")"
TOPDIR="$(realpath "$(dirname "$0")/..")"
CACHEDIR="$DIR/_cache"
TEMPDIR="$DIR/_temp"
OUTDIR="$DIR/_out"
rm -rf "$TEMPDIR"
mkdir -p "$CACHEDIR" "$TEMPDIR" "$OUTDIR"
cd "$CACHEDIR"

# Clone git repositories
clone_repo calamares-extensions "$CALAMARES_EXT_REPO" "$CALAMARES_EXT_REV"
clone_repo pmbootstrap "$PMBOOTSTRAP_REPO" "$PMBOOTSTRAP_REV"
clone_repo pmaports "$PMAPORTS_REPO" "$PMAPORTS_REV"

# Source deviceinfo
DEVICE_PMAPORT="$(find_device_pmaport)"
. "$DEVICE_PMAPORT/deviceinfo"

# Initialize pmbootstrap (mind the wrapper above!)
echo "NOTE: pmbootstrap log output is in: $TEMPDIR/log.txt"
pmbootstrap_init
pmbootstrap config device "$DEVICE"
pmbootstrap config ui none

# Build calamares-extensions and postmarketos-ondev packages from source (so it's easy to modify them)
pmbootstrap -y zap -p
pmbootstrap build calamares-extensions --arch="$deviceinfo_arch" --src="$CACHEDIR/calamares-extensions"
pmbootstrap build postmarketos-ondev --arch="$deviceinfo_arch" --src="$TOPDIR"

# Generate the installer OS
pmbootstrap install --ondev
