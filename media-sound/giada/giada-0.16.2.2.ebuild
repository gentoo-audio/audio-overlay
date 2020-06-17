# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Minimal, hardcore audio tool for DJs, live performers and electronic musicians"
HOMEPAGE="https://giadamusic.com/"
SRC_URI="https://giadamusic.com/data/${P}-src.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa jack pulseaudio vst"

# TODO media-pugins/juce: https://juce.com/
DEPEND="
	dev-libs/jansson
	media-libs/libsamplerate
	media-libs/libsndfile
	media-libs/rtmidi
	x11-libs/fltk
"
RDEPEND="${DEPEND}"
BDEPEND=""

S=${WORKDIR}/${P}-src

src_prepare() {
	default
	sed -i 's!FL/Fl.H!fltk/&!g' configure.ac
	use alsa  || sed -i 's/ -D__LINUX_ALSA__//'  Makefile.am
	use jack  || sed -i 's/ -D__UNIX_JACK__//'   Makefile.am
	use pulseaudio || sed -i 's/ -D__LINUX_PULSE__//;s/ -lpulse-simple -lpulse//' Makefile.am
	eautoreconf
}

src_configure() {
	# --disable-vst not treated well
	econf --target=linux $(use vst && use_enable vst) \
		CFLAGS="-I/usr/include/fltk/ ${CFLAGS}" \
		CXXFLAGS="-I/usr/include/fltk/ ${CXXFLAGS}" \
		LDFLAGS="-L/usr/$(get_libdir)/fltk/ ${LDFLAGS}"
}
