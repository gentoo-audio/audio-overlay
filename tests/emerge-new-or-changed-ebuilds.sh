#!/usr/bin/env bash
# Determine which ebuilds are new or changed and emerge them in a clean amd64 stage3
set -ex

SCRIPT_PATH=$(dirname "$0")

# Get list of new or changed ebuilds
if [[ ! -z "${CIRCLECI}" ]]; then
  # For some reason CircleCI does some crazy stuff with git/master which breaks the normal git workflow :|
  # See https://discuss.circleci.com/t/checkout-script-adds-commits-to-master-from-circle-branch/14194
  # So we hard reset master here to make it usable again
  git checkout master
  git reset --hard origin/master
  git checkout -
  EBUILDS=($(git diff --name-only --diff-filter=d "master..${CIRCLE_BRANCH}" | grep '\.ebuild$')) || true
else
  EBUILDS=($(git diff --name-only --diff-filter=d "${TRAVIS_BRANCH:-master}" | grep '\.ebuild$')) || true
fi

# Emerge the ebuilds in a clean stage3
for EBUILD in "${EBUILDS[@]}"
do
  "${SCRIPT_PATH}/emerge-ebuild.sh" "${EBUILD}"
done
