#!/usr/bin/env bash
# Determine which ebuilds are new or changed
set -e

if [ "${DEBUG}" = True ]; then
  set -x
fi

if [[ -n "${CIRCLECI}" ]]; then
  # For some reason CircleCI does some crazy stuff with git/master which breaks the normal git workflow :|
  # See https://discuss.circleci.com/t/checkout-script-adds-commits-to-master-from-circle-branch/14194
  # So we hard reset master here to make it usable again
  git checkout master
  git reset --hard origin/master
  git checkout -
  EBUILDS=($(git diff --name-only --diff-filter=d "master..${CIRCLE_BRANCH}" | grep '\.ebuild$')) || true
else
  EBUILDS=($(git diff --name-only --diff-filter=d master | grep '\.ebuild$')) || true
fi

echo "${EBUILDS[@]}"
