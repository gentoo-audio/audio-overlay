# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit qmake-utils

DESCRIPTION="Shuriken Beat Slicer"
HOMEPAGE="https://rock-hopper.github.io/shuriken/"
SRC_URI="https://github.com/rock-hopper/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	dev-qt/qtopengl:5
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	media-libs/alsa-lib
	media-libs/aubio
	media-libs/liblo
	media-libs/libsamplerate
	media-libs/libsndfile
	media-libs/rubberband
	virtual/jack
"
RDEPEND="${DEPEND}"

src_prepare() {
	mkdir lib
	sed -i 's:libsndlib_shuriken.a:../../lib/&:' src/SndLibShuriken/makefile.in
	default
}

src_configure() {
	eqmake5
	cd src/SndLibShuriken
	econf --without-audio --without-s7
}

src_compile() {
	pushd src/SndLibShuriken
	emake
	popd
	emake
}

src_install() {
	dobin release/shuriken
	dodoc README.md TODO
}
