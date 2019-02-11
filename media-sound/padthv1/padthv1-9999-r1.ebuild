# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit xdg-utils

DESCRIPTION="Old-school polyphonic additive synthesizer"
HOMEPAGE="http://padthv1.sourceforge.net"
if [[ ${PV} == *9999 ]]; then
	inherit git-r3 autotools
	EGIT_REPO_URI="https://github.com/rncbc/${PN}.git"
	KEYWORDS=""
else
	SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
	KEYWORDS="~amd64"
fi
LICENSE="GPL-2+"
SLOT="0"

IUSE="debug standalone alsa lv2 osc"
REQUIRED_USE="
	|| ( standalone lv2 )
	alsa? ( standalone )"

RDEPEND="
	>=sci-libs/fftw-3
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	standalone? ( virtual/jack )
	alsa? ( media-libs/alsa-lib )
	lv2? ( media-libs/lv2 )
	osc? ( media-libs/liblo )
"
DEPEND="${RDEPEND}"

src_prepare() {
	if [[ ${PV} == *9999 ]]; then
		eautoreconf
	fi
	default
}

src_configure() {
	# Disable stripping
	echo "QMAKE_STRIP=" >> src/src_core.pri.in
	echo "QMAKE_STRIP=" >> src/src_jack.pri.in

	local -a myeconfargs=(
		$(use_enable debug)
		$(use_enable standalone jack)
		$(use_enable alsa alsa-midi)
		$(use_enable lv2)
		$(use_enable osc liblo)
	)
	econf "${myeconfargs[@]}"
}

pkg_postinst() {
	xdg_mimeinfo_database_update
}

pkg_postrm() {
	xdg_mimeinfo_database_update
}
