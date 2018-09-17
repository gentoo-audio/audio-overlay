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
All tests that are meant to be executed by the user or by CI can be found in the root of the `./tests` directory.

Note that the tests will create a binary package cache at `${HOME}/.portage-pkgdir`.

#### Dependencies
All tests need `app-emulation/docker`, they use the [gentoo/stage3-amd64](https://hub.docker.com/r/gentoo/stage3-amd64/) and [gentoo/portage](https://hub.docker.com/r/gentoo/portage/) image.

#### Test overview
- `./tests/emerge-ebuild.sh <path>/<to>/<ebuild>.ebuild`
Emerges the ebuild in a clean amd64 stage3.

- `./tests/emerge-ebuild-usecombis.sh <path>/<to>/<ebuild>.ebuild`
Emerges the ebuild once for every possible USE flag combination.
Depending on the amount of USE flags and the package's compilation time this might take a while.

- `./tests/emerge-new-or-changed-ebuilds.sh`
Determines which ebuilds are new and/or changed and will execute `./tests/emerge-ebuild.sh` for all of them.
Should be run from a branch that contains new or changed ebuilds.
This test is run for every Pull Request.
This test needs `dev-vcs/git`.

- `./tests/emerge-random-ebuild.sh`
A random ebuild is picked and emerged using `./tests/emerge-ebuild.sh` to validate that the chosen ebuild can still be emerged correctly.
This test is run daily on CI.

- `./tests/emerge-random-live-ebuild.sh`
A random live (`9999`) ebuild is picked and emerged using `./tests/emerge-ebuild.sh` to validate that the chosen ebuild can still be emerged correctly.
This test is run daily on CI.

- `./tests/repoman.sh`
Validates if the ebuilds, metadata and other overlay files are correct.
This is done using [repoman](https://wiki.gentoo.org/wiki/Repoman).
This test is run for every Pull Request.

- `./tests/newversioncheck.sh`
Checks if a new version of any of the packages in the overlay is released.
This is done using [newversionchecker](https://github.com/simonvanderveldt/newversionchecker).
If a new version has been released an issue requesting a version bump will be created.
This check is run daily on CI.


#### Test configuration
All test configuration can be found in `./tests/resources`.

##### Emerge tests
To enable configuring packages for the `emerge` tests a `.conf` file matching the package is sourced before the package is emerged. These `.conf` files should be placed in the `./tests/resources/packages` directory using the same `<category>/<package>` structure as the overlay itself.
<br>For example to configure the package `media-sound/somesynth-1.2.3` the `.conf` file should be called `./tests/resources/packages/media-sound/somesynth-1.2.3.conf`.

##### New version check
The new version is configured using `./test/resources/newversionchecker.toml`.
