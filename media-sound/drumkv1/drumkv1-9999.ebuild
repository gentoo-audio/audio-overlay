# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg

DESCRIPTION="An old-school all-digital drum-kit sampler synthesizer with stereo fx"
HOMEPAGE="https://drumkv1.sourceforge.net/"

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/rncbc/${PN}.git"
else
	MY_PV="$(ver_rs 1- _)"
	MY_P="${PN}_${MY_PV}"

	SRC_URI="https://github.com/rncbc/${PN}/archive/${MY_P}.tar.gz"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${MY_P}"
fi

LICENSE="GPL-2+"
SLOT="0"
IUSE="+standalone alsa lv2 osc qt6"
REQUIRED_USE="
	|| ( standalone lv2 )
	alsa? ( standalone )
"

RDEPEND="
	dev-qt/qtbase:6=[gui]
	media-libs/libsndfile

	standalone? ( virtual/jack )
	alsa? ( media-libs/alsa-lib )
	lv2? ( media-libs/lv2 )
	osc? ( media-libs/liblo )

	qt6? (
		dev-qt/qtbase:6=[gui,widgets,xml]
	)
	!qt6? (
		dev-qt/qtcore:5=
		dev-qt/qtgui:5=
		dev-qt/qtwidgets:5=
		dev-qt/qtxml:5=
	)
"
# drumkv1 for some reason wants qtsvg as dependency during build, but runs without it
DEPEND="
	${RDEPEND}
	qt6? ( dev-qt/qtsvg:6= )
	!qt6? ( dev-qt/qtsvg:5= )
"

src_prepare() {
	sed -e 's/COMMAND strip/COMMAND true/' \
		-i src/CMakeLists.txt \
		|| die

	cmake_src_prepare
}

src_configure() {
	local -a mycmakeargs=(
		-DCONFIG_ALSA_MIDI=$(usex alsa)
		-DCONFIG_JACK=$(usex standalone)
		-DCONFIG_JACK_SESSION=$(usex standalone)
		-DCONFIG_JACK_MIDI=$(usex standalone)
		-DCONFIG_LV2=$(usex lv2)
		-DCONFIG_LIBLO=$(usex osc)
		-DCONFIG_QT6=$(usex qt6)
	)
	cmake_src_configure
}
