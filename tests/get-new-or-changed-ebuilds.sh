#!/usr/bin/env bash
# Determine which packages/ebuilds are new or changed
# If there are changes to .ebuild files return the list of changed ebuilds
# If there are no changes to .ebuild files determine which package(s) is/are changed
# and return all of the .ebuild files for those package(s)
# All ebuilds need to be returned because there is no way to determine which specific ebuild is impacted
# by a change to for example files/patches or metadata changes
# If no changed .ebuild files or changed packages can be found return nothing
set -e

if [ "${DEBUG}" = True ]; then
  set -x
fi

if [[ -n "${CIRCLECI}" ]]; then
  # For some reason CircleCI does some crazy stuff with git/master which breaks the normal git workflow :|
  # See https://discuss.circleci.com/t/checkout-script-adds-commits-to-master-from-circle-branch/14194
  # So we hard reset master here to make it usable again
  git checkout master > /dev/null 2>&1
  git reset --hard origin/master > /dev/null 2>&1
  git checkout - > /dev/null 2>&1
  DIFF_REFS="master..${CIRCLE_BRANCH}"
else
  DIFF_REFS="master"
fi

# Get ebuild files that are changed
EBUILDS=($(git diff --name-only --diff-filter=d "${DIFF_REFS}" | grep '\.ebuild$')) || true
# If no ebuild files are changed check if there are any other changes to packages
if [ ${#EBUILDS[@]} -eq 0 ]; then
  # Ignore everything that's not a package by only picking up paths that are >= 3 levels deep
  # This excludes everything, except for some stuff in the "tests" directory, so explicitly exclude the "tests" directory
  PACKAGES=($(git diff --name-only --diff-filter=d "${DIFF_REFS}" ':!tests' | awk -F/ '{if (NF>=3) print $1"/"$2;}' | sort -u)) || true
  for PACKAGE in "${PACKAGES[@]}"
  do
    shopt -s nullglob
    EBUILDS+=(${PACKAGE}/*.ebuild)
  done
fi

echo "${EBUILDS[@]}"
