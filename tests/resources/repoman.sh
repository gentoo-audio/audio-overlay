#!/usr/bin/env bash
# "Lint" using repoman if any ebuilds have basic issues
# In case of a PR the result is added as a comment to the PR
set -e

if [ "${DEBUG}" = True ]; then
  set -x
fi

# Disable news messages from portage and disable rsync's output
export FEATURES="-news" PORTAGE_RSYNC_EXTRA_OPTS="-q"

# Install dependencies
emerge -q --buildpkg --usepkg dev-vcs/git app-portage/repoman dev-python/pip
pip install --user https://github.com/simonvanderveldt/travis-github-pr-bot/archive/master.zip
PATH="${HOME}/.local/bin:$PATH"

REPOMAN_OUTPUT=""
REPOMAN_EXITCODES=0

if [[ -n "${1}" ]]; then
  IFS=' ' read -ra PACKAGES <<< "${@}"
  for PACKAGE in "${PACKAGES[@]}"
  do
    pushd "${PACKAGE}"
    REPOMAN_OUTPUT+="${PACKAGE}: $(repoman full -d -q)\n" || REPOMAN_EXITCODES+=${?}
    popd
  done
else
  REPOMAN_OUTPUT+=$(repoman full -d -q) || REPOMAN_EXITCODES+=${?}
fi

echo -e "${REPOMAN_OUTPUT}"
# Post repoman output as comment on PR when running on CI
if [[ -n "${CIRCLE_PULL_REQUEST}" ]]; then
  echo -e "${REPOMAN_OUTPUT}" | travis-bot --description "Repoman QA results:"
fi

if (( REPOMAN_EXITCODES > 0 )); then
  exit 1
fi
