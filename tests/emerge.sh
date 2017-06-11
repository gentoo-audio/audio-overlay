#!/usr/bin/env sh
# Test merging of new or changed ebuild(s)
set -x

# Disable news messages from portage and disable rsync's output
export FEATURES="-news" PORTAGE_RSYNC_EXTRA_OPTS="-q"

# Update the portage tree and install dependencies
emerge --sync
emerge -q --buildpkg --usepkg dev-vcs/git

# Setup overlay
mkdir -p /etc/portage/repos.conf
cat > /etc/portage/repos.conf/localrepo.conf <<EOF
[audio-overlay]
location = /usr/local/portage
EOF

# Get list of new or changed ebuilds
EBUILDS=($(git diff --name-only --diff-filter=d "${BASE_BRANCH}" | grep ".ebuild"))
# Emerge the ebuilds
for EBUILD in "${EBUILDS[@]}"
do
  unset ACCEPT_KEYWORDS
  unset USE
  PKG_NAME=$(basename "${EBUILD}" ".ebuild")
  PKG_CATEGORY="${EBUILD%%/*}"
  PKG_ENV_FILE="./tests/packages/${PKG_CATEGORY}/${PKG_NAME}.env"
  # Install dependencies
  emerge -q  --buildpkg --usepkg --onlydeps --autounmask=y --autounmask-continue=y "=${PKG_CATEGORY}/${PKG_NAME}"
  # Source ebuild specific env vars
  if [ -f "${PKG_ENV_FILE}" ]; then
    source "${PKG_ENV_FILE}"
  fi
  # Install package
  emerge -q "=${PKG_CATEGORY}/${PKG_NAME}"
done
