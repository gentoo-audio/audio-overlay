# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

COMMIT="a5e9ad191710c69a962151e68e3988664bcefe78"

DESCRIPTION="EKO is a simple sound editor"
HOMEPAGE="http://semiletov.org/eko/ https://github.com/psemiletov/eko"
SRC_URI="https://github.com/psemiletov/eko/archive/${COMMIT}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="qt5"

inherit qmake-utils eutils

DEPEND="media-libs/portaudio
        media-libs/libsndfile
		media-libs/libsamplerate
		qt5? ( dev-qt/qtgui:5 )
		!qt5? ( dev-qt/qtgui:4 )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-${COMMIT}"

DOCS=( AUTHORS COPYING NEWS NEWS-RU README TODO )
HTML_DOCS=( manuals )

src_configure() {
	if use qt5; then
		eqmake5 PREFIX="${EPREFIX}/usr"
	else
		eqmake4 PREFIX="${EPREFIX}/usr"
	fi
}

src_install() {
	emake install INSTALL_ROOT="${D}" DESTDIR="${D}"
}
