#!/usr/bin/env bash
# Check if a new version of any of the projects in this overlay is released
# Will create an issue requesting a version bump if a new version is found
set -ex

docker run --rm -ti \
  -e GITHUB_API_TOKEN \
  -v "${PWD}/tests/resources/newversionchecker.toml":/app/newversionchecker.toml \
  simonvanderveldt/newversionchecker
