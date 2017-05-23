# Audio overlay

Overlay containing pro audio applications

## How to use this overlay
- Add an entry to [`/etc/portage/repos.conf`](https://wiki.gentoo.org/wiki//etc/portage/repos.conf):
```ini
[audio-overlay]
# Use the location where you store your overlays
location = /usr/local/overlay/audio-overlay
sync-type = git
sync-uri = https://github.com/gentoo-audio/audio-overlay.git
auto-sync = yes
```
- Sync
```sh
emerge --sync
```
- You're all set. Go and install a package :)

## Problems?
If you run into problems please [create an issue](https://github.com/gentoo-audio/audio-overlay/issues/new) or send a pull request if you already know how to fix it :)

## Automated quality control
- GitHub's [branch protection](https://help.github.com/articles/about-protected-branches/) is enabled for the `master` branch
- Changes can only be done using [pull requests](https://help.github.com/articles/about-pull-requests/) and need at least one approval
