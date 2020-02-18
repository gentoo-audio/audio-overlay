# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils xdg

DESCRIPTION="Application to learn classical score notation"
HOMEPAGE="https://sourceforge.net/projects/nootka/"
SRC_URI="mirror://sourceforge/${PN}/${P}-source.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="jack pulseaudio"

DEPEND="jack? ( virtual/jack )
	pulseaudio? ( media-sound/pulseaudio )
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
	media-libs/alsa-lib
	media-libs/libogg
	media-libs/libsoundtouch
	media-libs/libvorbis
	media-sound/vorbis-tools
	sci-libs/fftw:3.0"
RDEPEND="${DEPEND}"
BDEPEND=""

S=${WORKDIR}/${P}-source

src_prepare() {
	cmake-utils_src_prepare
	sed -i -e 's:share/doc/nootka:share/nootka/doc:g' \
		src/plugins/about/taboutnootka.cpp \
		packaging/rpm/nootka.spec.in \
		CMakeLists.txt || die
	sed -i -e 's/nootka.1.gz/nootka.1/' CMakeLists.txt || die
	gunzip packaging/nootka.1.gz
	default
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_JACK=$(usex jack ON OFF)
		-DENABLE_PULSEAUDIO=$(usex pulseaudio ON OFF)
	)
	cmake-utils_src_configure
}
