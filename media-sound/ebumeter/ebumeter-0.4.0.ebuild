# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
inherit base toolchain-funcs

DESCRIPTION="Loudness measurement according to EBU-R128"
HOMEPAGE="http://kokkinizita.linuxaudio.org/linuxaudio"
SRC_URI="http://kokkinizita.linuxaudio.org/linuxaudio/downloads/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=media-libs/libclthreads-2.4.0
	>=media-libs/libclxclient-3.6.1
	media-libs/libpng
	media-libs/libsndfile
	>=media-sound/jack-audio-connection-kit-0.100"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${P}/source
RESTRICT="mirror"

DOCS=(../AUTHORS ../README ../doc/loudness-meter-pres.pdf
	  ../doc/loudness-meter.pdf)
HTML_DOCS=(../doc/)

src_compile() {
	CXX="$(tc-getCXX)" base_src_make PREFIX="${EPREFIX}/usr"
}

src_install() {
	base_src_install PREFIX="${EPREFIX}/usr"
	make_desktop_entry ${PN} ${PN} "" "AudioVideo;Audio;"
}
