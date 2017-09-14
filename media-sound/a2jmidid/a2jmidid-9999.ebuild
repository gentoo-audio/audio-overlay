# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="6"

PYTHON_COMPAT=( python2_7 )
inherit git-r3 python-single-r1 waf-utils

DESCRIPTION="Daemon for exposing legacy ALSA sequencer applications in JACK MIDI system."
HOMEPAGE="http://home.gna.org/a2jmidid/"
EGIT_REPO_URI="https://github.com/nick87720z/${PN}.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="dbus"
PYTHON_REQ_USE="threads(+)"

RDEPEND="media-libs/alsa-lib
	virtual/jack
	dbus? ( sys-apps/dbus )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=( AUTHORS NEWS README internals.txt )

src_configure() {
	NO_WAF_LIBDIR="1"
	waf-utils_src_configure \
	$(usex dbus "" --disable-dbus)
}

src_install() {
	waf-utils_src_install
	python_fix_shebang "${ED}"
}
