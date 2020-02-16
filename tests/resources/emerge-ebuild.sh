#!/usr/bin/env bash
# Tests emering of an ebuild, installs dependencies first
# Takes the path to an ebuild as the one and only argument
# Sources ebuild specific config from ./packages/<category>/<PN>.conf and
# ./packages/<category>/<P>.conf if those files exist
# Depends on qatom from app-portage/portage-utils
set -e

if [ "${DEBUG}" = True ]; then
  set -x
fi

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <ebuild category>/<ebuild name>/<ebuild filename>.ebuild" >&2
  exit 1
fi

EBUILD_PATH="${1}"

# Enable binpkg-multi-instance mainly for keeping binpkgs built with different USE flags
# Disable news messages from portage as well as the IPC, network and PID sandbox to get rid of the
# "Unable to unshare: EPERM" messages without requiring the container to be ran in priviliged mode
# Also disable rsync's output
export FEATURES="binpkg-multi-instance -news -ipc-sandbox -network-sandbox -pid-sandbox" PORTAGE_RSYNC_EXTRA_OPTS="-q"

echo "Emerging dependencies"
emerge -q --buildpkg --usepkg app-portage/portage-utils

EBUILD_FILENAME=$(basename "${EBUILD_PATH}" ".ebuild")
EBUILD_CATEGORY="${EBUILD_PATH%%/*}"
EBUILD="${EBUILD_CATEGORY}/${EBUILD_FILENAME}"
echo "Emerging ${EBUILD}"

# Set portage's distdir to /tmp/distfiles
# This is a workaround for a bug in portage/git-r3 where git-r3 can't
# create the distfiles/git-r3 directory when no other distfiles have been
# downloaded by portage first, which happens when using binary packages
# https://bugs.gentoo.org/481434
export DISTDIR="/tmp/distfiles"

# Setup overlay
mkdir -p /etc/portage/repos.conf
cat > /etc/portage/repos.conf/localrepo.conf <<EOF
[audio-overlay]
location = /usr/local/portage
EOF

# Source ebuild specific env vars
unset ACCEPT_KEYWORDS
unset USE
PKG_CATEGORY=$(qatom -F "%{CATEGORY}" ${EBUILD})
PKG_NAME=$(qatom -F "%{PN}" ${EBUILD})
PKG_FULL_NAME=$(qatom -F "%{PF}" ${EBUILD})
# Source versionless config
if [ -f "./tests/resources/packages/${PKG_CATEGORY}/${PKG_NAME}.conf" ]; then
  source "./tests/resources/packages/${PKG_CATEGORY}/${PKG_NAME}.conf"
fi
# Source version specific config
if [ -f "./tests/resources/packages/${PKG_CATEGORY}/${PKG_FULL_NAME}.conf" ]; then
  source "./tests/resources/packages/${PKG_CATEGORY}/${PKG_FULL_NAME}.conf"
fi

# Emerge dependencies first
emerge --quiet-build --buildpkg --usepkg --onlydeps --autounmask=y --autounmask-continue=y "=${PKG_CATEGORY}/${PKG_FULL_NAME}"

# Emerge the ebuild itself
emerge -v "=${PKG_CATEGORY}/${PKG_FULL_NAME}"
