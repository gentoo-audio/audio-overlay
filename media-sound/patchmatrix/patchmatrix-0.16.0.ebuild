# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson xdg

DESCRIPTION="JACK patchbay in flow matrix style"
HOMEPAGE="https://gitlab.com/OpenMusicKontrollers/patchmatrix https://github.com/OpenMusicKontrollers/patchmatrix"
SRC_URI="https://gitlab.com/OpenMusicKontrollers/patchmatrix/-/archive/${PV}/${P}.tar.bz2"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	dev-libs/expat
	media-libs/lv2
	x11-libs/libX11
	x11-libs/libXext
	virtual/jack
	virtual/opengl
"
RDEPEND="${DEPEND}"
BDEPEND=""

src_configure() {
	meson_src_configure
}
