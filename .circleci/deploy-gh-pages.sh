#!/usr/bin/env bash
# Commit generated docs to gh-pages branch
set -e

git config user.email "${GITHUB_EMAIL}"
git config user.name "${GITHUB_NAME}"

set -x
git checkout gh-pages
cp /tmp/docs/* .
git add -A .
git commit --allow-empty -m "Deploy commit ${CIRCLE_SHA1} to GitHub Pages [skip ci]"
git show --stat-count=10 HEAD
git push origin gh-pages
