#!/usr/bin/env bash
# "Lint" using pkgcheck if any ebuilds have basic issues
# In case of a PR the result is added as a comment to the PR
set -e

if [ "${DEBUG}" = True ]; then
  set -x
fi

# Enable binpkg-multi-instance mainly for keeping binpkgs built with different USE flags
# Disable news messages from portage as well as the IPC, network and PID sandbox to get rid of the
# "Unable to unshare: EPERM" messages without requiring the container to be ran in priviliged mode
# Also disable rsync's output
export FEATURES="binpkg-multi-instance parallel-install -news -ipc-sandbox -network-sandbox -pid-sandbox" PORTAGE_RSYNC_EXTRA_OPTS="-q"

# Ensure we use dev-lang/rust-bin
echo "dev-lang/rust" > /etc/portage/package.mask/audio-overlay

# Install dependencies
emerge -q --buildpkg --usepkg dev-vcs/git dev-util/pkgcheck

REPORT="$(mktemp)"

# We don't need to ensure ownership of the directory is sane,
# since this is run inside a throwaway container
git config --global --add safe.directory '/usr/local/portage'

echo "Scanning repo..."
pkgcheck scan -R JsonStream "$@" > "$REPORT"
PKGCHECK_EXITCODE=$?

echo "Scanning repo... done"
pkgcheck replay --color=true "$REPORT"

exit $PKGCHECK_EXITCODE
