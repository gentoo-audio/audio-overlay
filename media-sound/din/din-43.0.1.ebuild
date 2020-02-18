# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic xdg

DESCRIPTION="a software musical instrument and audio synthesizer"
HOMEPAGE="http://dinisnoise.org/"
SRC_URI="https://archive.org/download/dinisnoise_source_code/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="jack"

RDEPEND="
	jack? ( virtual/jack )
	dev-lang/tcl:0=
	media-libs/alsa-lib
	media-libs/liblo
	net-libs/libircclient
	sci-libs/fftw:3.0
	virtual/opengl
	x11-libs/libX11
"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	default
	sed -i -e 's///' pixmaps/din.desktop
	append-cxxflags -D__UNIX_$(usex jack JACK ALSA)__

	use jack && \
		sed -i -e "/LIBS/s/$/ $(pkg-config --libs jack)/" \
			src/Makefile.am
	eautoreconf
}
