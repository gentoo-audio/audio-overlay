# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{3_6,3_7,3_8,3_9} )
PYTHON_REQ_USE='threads(+)'

inherit meson python-single-r1

DESCRIPTION="LADI Session Handler - a session management system for JACK applications"
HOMEPAGE="https://ladish.org"
if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://git.nedk.org/lad/${PN}.git"
	KEYWORDS=""
	EGIT_SUBMODULES=()
else
	inherit vcs-snapshot
	SRC_URI="https://github.com/LADI/ladish/archive/${P}.tar.gz
		https://git.nedk.org/lad/ladish.git/plain/waf -> ${P}-waf-2.0.22"
	KEYWORDS="~amd64"
fi
LICENSE="GPL-2"
SLOT="0"
RESTRICT="mirror"

IUSE="lash gladish"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

BUILD_DIR="${WORKDIR}/${P}/build"

RDEPEND="media-libs/alsa-lib
	media-sound/jack2[dbus]
	sys-apps/dbus
	${PYTHON_DEPS}
	lash? ( !media-sound/lash )
	gladish? ( dev-libs/dbus-glib dev-cpp/gtkmm:2.4 dev-cpp/libgnomecanvasmm )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=( AUTHORS README NEWS )

src_configure() {
	local emesonargs=(
		$(meson_feature lash)
		$(meson_feature gladish)
	)
	meson_src_configure
}
