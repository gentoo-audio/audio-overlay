#!/usr/bin/env bash
# Create markdown file with an overview of all our packages
# Ready to be rendered into a site by GitHub Pages
set -ex

# Create volume container named "portage" with today's gentoo tree in it
# Ensure the portage image is up to date
docker pull gentoo/portage
# Clean up in case an old volume container exists
docker rm -f portage || true
# Create the new volume container
docker create --name portage gentoo/portage

# Run overlay-packagelist to render our template
mkdir -p docs/site
rm -rf docs/site/*

# The sed replacement is a workaround for an issue on CircleCI where the echo'd output
# gets prefixed with "^@^@"
docker run --rm -ti \
  --volumes-from portage \
  -v "${HOME}/.portage-pkgdir":/usr/portage/packages \
  -v "${PWD}":/usr/local/portage \
  -w /usr/local/portage simonvanderveldt/overlay-packagelist \
  docs/index.md.j2 | sed -e "s/^\^@\^@//" > docs/site/index.md
