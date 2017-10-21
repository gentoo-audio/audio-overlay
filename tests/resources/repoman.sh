#!/usr/bin/env bash
# "Lint" using repoman if any ebuilds have basic issues
# In case of a PR the result is added as a comment to the PR
set -ex

# Disable news messages from portage and disable rsync's output
export FEATURES="-news" PORTAGE_RSYNC_EXTRA_OPTS="-q"

# Update the portage tree and install dependencies
emerge --sync
emerge -q --buildpkg --usepkg dev-vcs/git app-portage/repoman

# Run the tests
repoman full -d
