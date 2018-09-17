#!/usr/bin/env bash
# Tests emering of an ebuild, installs dependencies first
# Takes the path to an ebuild as the one and only argument
# Sources ebuild specific config from ./packages/<category>/<PN>.conf and
# ./packages/<category>/<P>.conf if those files exist
# Depends on qatom from app-portage/portage-utils
set -ex

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <ebuild category>/<ebuild name>/<ebuild filename>.ebuild" >&2
  exit 1
fi

SCRIPT_NAME=$(basename "${0}")
EBUILD_PATH="${1}"

# Disable news messages from portage and disable rsync's output
export FEATURES="binpkg-multi-instance -news" PORTAGE_RSYNC_EXTRA_OPTS="-q"

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

if [ "${SCRIPT_NAME}" == "emerge-ebuild-usecombis.sh" ]; then
  echo "Emerging all possible USE flag combinations for ${EBUILD}"
  # Use 9999 until a release containing https://github.com/gentoo/tatt/pull/34 is made
  echo 'app-portage/tatt **' >> /etc/portage/package.accept_keywords/tatt
  emerge -q --buildpkg --usepkg app-portage/tatt
  # Replace templates
  rm /usr/share/tatt/templates/use-loop
  echo "" > /usr/share/tatt/templates/use-test-snippet
cat > /usr/share/tatt/templates/use-snippet <<EOF
# Emerge dependencies first
@@USE@@ emerge --quiet-build --buildpkg --usepkg --onlydeps --autounmask=y --autounmask-continue=y @@CPV@@
# Emerge the ebuild itself
@@USE@@ emerge -v @@CPV@@
EOF
cat > /usr/share/tatt/templates/use-header << EOF
#!/bin/bash
set -ex

source "@@TEMPLATEDIR@@tatt_functions.sh"
EOF

  # Generate script to emerge all USE flag combinations
  pushd /tmp
  tatt -u "=${EBUILD}"

  # Run emerge script
  ./${PKG_NAME}-useflags.sh
  popd
else
  echo "Emerging dependencies for ${EBUILD}"
  emerge --quiet-build --buildpkg --usepkg --onlydeps --autounmask=y --autounmask-continue=y "=${PKG_CATEGORY}/${PKG_FULL_NAME}"

  echo "Emerging ${EBUILD}"
  emerge -v "=${PKG_CATEGORY}/${PKG_FULL_NAME}"
fi
