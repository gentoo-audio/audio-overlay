# Audio overlay [![Build Status](https://travis-ci.org/gentoo-audio/audio-overlay.svg?branch=master)](https://travis-ci.org/gentoo-audio/audio-overlay)

Gentoo/Funtoo overlay containing pro audio applications

## How to use this overlay
- Add the following entry to [`/etc/portage/repos.conf`](https://wiki.gentoo.org/wiki//etc/portage/repos.conf) and sync using `emerge --sync`
```ini
[audio-overlay]
location = /<path>/<to>/<your>/<overlays>/audio-overlay
sync-type = git
sync-uri = https://github.com/gentoo-audio/audio-overlay.git
auto-sync = yes
```
- Or if you use [layman](https://wiki.gentoo.org/wiki/Layman) add the overlay using `layman -a audio-overlay` and sync using `layman -s audio-overlay`

## Contact
Join us at the `#proaudio-overlay` channel at `irc.freenode.org` or [create an issue](https://github.com/gentoo-audio/audio-overlay/issues/new).

## Quality control
- GitHub's [branch protection](https://help.github.com/articles/about-protected-branches/) is enabled for the `master` branch.
- Changes can only be done using [pull requests](https://help.github.com/articles/about-pull-requests/) and need at least one approval.
- Pull requests can only be merged if they pass the automated tests, which are run by [Travis CI](https://travis-ci.org/gentoo-audio/audio-overlay).
<br>We have a zero-tolerance policy for test failures and warnings, only changes that have no failures and warnings are merged.

### Automated tests
All tests that are meant to be executed by the user or by CI can be found in the `./tests` directory.

All tests need `app-emulation/docker` to be installed.

#### Pull Requests
Every pull request must pass the following tests before it can be merged:
- Validation if the ebuild(s), metadata and other overlay files are correct. This is done using [repoman](https://wiki.gentoo.org/wiki/Repoman).
<br>Run this test using `./tests/repoman.sh`.
- Validation if the ebuilds that are new or changed in the Pull Request can be emerged. This is done in a clean amd64 stage3.
<br>Run this test using `./tests/emerge-new-or-changed-ebuilds.sh` from the branch which contains the new or changed ebuild(s).
<br>Note that this will create a binary package cache at `${HOME}/.portage-pkgdir`.

#### Daily checks
Every day the following tests are run:
- A random ebuild is picked and emerged to validate that it can still be emerged correctly. This is done in a clean amd64 stage3.
<br>Run this test using `./tests/emerge-random-ebuild.sh`.
<br>Note that this will create a binary package cache at `${HOME}/.portage-pkgdir`.
- A check if a new version of any of the packages in the overlay is released. This is done using [newversionchecker](https://github.com/simonvanderveldt/newversionchecker). If a new version has been released an issue requesting a version bump will be created.
<br>Run this test using `./tests/newversioncheck.sh`.

#### Development
To check if an ebuild you're working on can be emerged without issue use `./tests/emerge-ebuild.sh <path>/<to>/<ebuild>.ebuild`. This is done in a clean amd64 stage3.
<br>For example to emerge the ebuild `media-sound/somesynth/somesynth-1.2.3.ebuild` run `./tests/emerge-ebuild.sh media-sound/somesynth/somesynth-1.2.3.ebuild`.
<br>Note that this will create a binary package cache at `${HOME}/.portage-pkgdir`.

Also see the tests described under [Pull Requests](#pull-requests).

#### Test configuration
All test configuration can be found in `./tests/resources`.

##### Emerge tests
To enable configuring packages for the `emerge` tests a `.conf` file matching the package is sourced before the package is emerged. These `.conf` files should be placed in the `./tests/resources/packages` directory using the same package category structure as the overlay itself.
<br>For example to configure the package `media-sound/somesynth-1.2.3` the `.conf` file should be called `./tests/resources/packages/media-sound/somesynth-1.2.3.conf`.

##### New version check
The new version check uses `./test/resources/newversionchecker.toml` as it's configuration.
