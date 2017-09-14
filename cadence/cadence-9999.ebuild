# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# requires proaudio overlay

EAPI=6

PYTHON_COMPAT=( python3_{4,5,6} )

inherit git-r3 python-single-r1

DESCRIPTION="Collection of tools useful for audio production"
HOMEPAGE="http://kxstudio.linuxaudio.org/"

SRC_URI=""
EGIT_BRANCH="master"
EGIT_REPO_URI="https://github.com/falkTX/Cadence.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

IUSE="+a2jmidid +capture pulseaudio +ladish"

#requires jack2, python3 for pyqt4 and dbus-python
#ladish pulls from git to workaround 404 at ladish.org

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}
   || ( >=media-sound/jack-audio-connection-kit-1[dbus]
   		media-sound/jack2[dbus] )
   dev-python/PyQt4[examples,${PYTHON_USEDEP}]
   dev-python/dbus-python[${PYTHON_USEDEP}]"

RDEPEND="${DEPEND}
   capture? ( media-sound/jack_capture )
   a2jmidid? ( media-sound/a2jmidid )
   pulseaudio? ( media-sound/pulseaudio[jack] )
   ladish? ( >=media-sound/ladish-9999-r1 )"

src_compile() {
   emake PREFIX="/usr"
}

src_install() {
   emake DESTDIR="${D}" PREFIX="/usr" install
}

pkg_pretend() {
	einfo "Most use flags, like pulseaudio, a2jmidid, etc only pull in dependencies"
	einfo "Cadence doesn't have any configure options yet, and will always try to support"
	einfo "these features, if installed."
}
