# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="C++ library for real-time resampling of audio signals"
HOMEPAGE="http://kokkinizita.linuxaudio.org/linuxaudio/"
SRC_URI="http://kokkinizita.linuxaudio.org/linuxaudio/downloads/${P}.tar.bz2"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

IUSE="-standalone"

RDEPEND="standalone? ( media-libs/libsndfile )"
DEPEND="${RDEPEND}"

DOCS="README"
HTML_DOCS="docs/"

PATCHES="${FILESDIR}/${P}-makefile-fixes.patch"

src_compile() {
	emake -C libs
	if use standalone; then
		emake -C apps
	fi
}

src_install() {
	emake -C libs DESTDIR="${D}" PREFIX="${EPREFIX}/usr" LIBDIR=$(get_libdir) install
	if use standalone; then
		emake -C apps DESTDIR="${D}" PREFIX="${EPREFIX}/usr" install
	fi
	default
}
