#!/usr/bin/env bash
# Tests emering of an ebuild
# Installs dependencies first
# Can use predefined env vars stored in ./packages/<category>/<ebuild>.env
set -ex

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <ebuild category>/<ebuild name>.ebuild" >&2
  exit 1
fi

EBUILD="${1}"
echo "Emerging ${EBUILD}"

# Disable news messages from portage and disable rsync's output
export FEATURES="binpkg-multi-instance -news" PORTAGE_RSYNC_EXTRA_OPTS="-q"

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
PKG_NAME=$(basename "${EBUILD}" ".ebuild")
PKG_CATEGORY="${EBUILD%%/*}"
PKG_CONF_FILE="./tests/resources/packages/${PKG_CATEGORY}/${PKG_NAME}.conf"
if [ -f "${PKG_CONF_FILE}" ]; then
  source "${PKG_CONF_FILE}"
fi

# Emerge dependencies first
emerge --quiet-build --buildpkg --usepkg --onlydeps --autounmask=y --autounmask-continue=y "=${PKG_CATEGORY}/${PKG_NAME}"

# Emerge the ebuild itself
emerge -v "=${PKG_CATEGORY}/${PKG_NAME}"
