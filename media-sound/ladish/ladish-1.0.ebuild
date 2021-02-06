# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{3_6,3_7,3_8,3_9} )

inherit meson python-single-r1

DESCRIPTION="LADI Session Handler - a session management system for JACK applications"
HOMEPAGE="https://gitlab.com/cocainefarm/ladish/${PN}.git"
if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.com/cocainefarm/ladish/${PN}.git"
	KEYWORDS=""
	EGIT_SUBMODULES=()
else
	SRC_URI="https://gitlab.com/cocainefarm/ladish/ladish/-/archive/${PV}/${P}.tar.gz"
	KEYWORDS="~amd64"
fi
LICENSE="GPL-2"
SLOT="0"
RESTRICT="mirror"

IUSE="debug doc"

RDEPEND="media-libs/alsa-lib
	media-sound/jack2[dbus]
	sys-apps/dbus
	dev-libs/expat"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	virtual/pkgconfig"

DOCS=( AUTHORS README NEWS )

src_configure() {
	local emesonargs=(
		$(meson_feature doc)
	)
	meson_src_configure
}
