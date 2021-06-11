# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake xdg

DESCRIPTION="An old-school all-digital drum-kit sampler synthesizer with stereo fx"
HOMEPAGE="http://samplv1.sourceforge.net/"
EGIT_REPO_URI="https://github.com/rncbc/${PN}.git"
if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/rncbc/${PN}.git"
	KEYWORDS=""
else
	MY_PV=$(ver_rs 1- _)
	SRC_URI="https://github.com/rncbc/${PN}/archive/${PN}_${MY_PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
	RESTRICT="mirror"
	S="${WORKDIR}/${PN}-${PN}_${MY_PV}"
fi
LICENSE="GPL-2+"
SLOT="0"

IUSE="debug standalone alsa lv2 nsm osc"
REQUIRED_USE="
	|| ( standalone lv2 )
	alsa? ( standalone )
	nsm? ( standalone )"

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	media-libs/libsndfile
	standalone? ( virtual/jack )
	alsa? ( media-libs/alsa-lib )
	lv2? ( media-libs/lv2 )
	osc? ( media-libs/liblo )
"
DEPEND="${RDEPEND}"

src_prepare() {
	sed -i 's:strip:true:' src/CMakeLists.txt || die
	cmake_src_prepare
}

src_configure() {
	local -a mycmakeargs=(
		-DCONFIG_LV2=$(usex lv2)
		-DCONFIG_JACK=$(usex standalone)
		-DCONFIG_LIBLO=$(usex osc)
		-DCONFIG_NSM=$(usex nsm)
		-DCONFIG_ALSA_MIDI=$(usex alsa)
		-DCONFIG_DEBUG=$(usex debug)
	)
	cmake_src_configure
}
