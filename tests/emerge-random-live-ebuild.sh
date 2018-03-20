#!/usr/bin/env bash
# Emerge a random live ebuild out of all the ebuilds in the overlay in a clean amd64 stage3
# Used to do continuous tests if our ebuilds still work
# As well as making sure Travis's cache of the master branch is filled
set -ex

SCRIPT_PATH=$(dirname "$0")

# Pick a random live ebuild
EBUILD=$(find . -regextype egrep -regex '.+9999(-r[0-9]+)?.ebuild' -printf '%P\n' | shuf -n1)

${SCRIPT_PATH}/emerge-ebuild.sh "${EBUILD}"
