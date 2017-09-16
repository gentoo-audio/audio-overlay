# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE='threads(+)'

inherit waf-utils python-any-r1 git-r3

DESCRIPTION="Modular patch bay for JACK-based audio and MIDI systems"
HOMEPAGE="https://drobilla.net/software/patchage"
EGIT_REPO_URI="https://git.drobilla.net/patchage.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="alsa debug doc jack-dbus light-theme session"

REQUIRED_USE="session? ( !jack-dbus )"

RDEPEND=">=dev-cpp/glibmm-2.14:2=
	>=dev-cpp/gtkmm-2.12:2.4=
	>=media-libs/ganv-9999[light-theme=]
	jack-dbus? ( || ( >=media-sound/jack-audio-connection-kit-0.120[dbus] 
	                  media-sound/jack2[dbus] )
		dev-libs/dbus-glib
        sys-apps/dbus )
	!jack-dbus? ( virtual/jack )
	alsa? ( media-libs/alsa-lib )
	!!media-sound/drobilla"

DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	dev-libs/boost
	virtual/pkgconfig
	doc? ( app-doc/doxygen )"

DOCS=( AUTHORS NEWS README )

src_configure() {
	waf-utils_src_configure \
		$(usex debug       --debug '') \
		$(usex alsa        '' --no-alsa) \
		$(usex jack-dbus   --jack-dbus '') \
		$(usex session     --jack-session-manage '') \
		$(usex light-theme --light-theme '') \
		$(usex doc         --docs '')
}

pkg_postinst() {
	use jack-dbus && {
		ewarn "OSC over jack-midi support doesn't work via jack-dbus"
	}
}

