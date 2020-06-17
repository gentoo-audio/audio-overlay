# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils flag-o-matic xdg

MY_PN=muse
MY_PV=${PV/_/}

DESCRIPTION="MusE is a digital audio workstation with support for both Audio and MIDI"
HOMEPAGE="https://muse-sequencer.org"
SRC_URI="mirror://sourceforge/l${MY_PN}/${MY_PN}-${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa dssi fluidsynth gtk ladspa lash lv2 osc realtime vst"

DEPEND="
	alsa? ( media-libs/alsa-lib )
	dssi? ( media-libs/dssi )
	fluidsynth? ( media-sound/fluidsynth )
	ladspa? ( media-libs/liblrdf )
	lash? ( media-sound/lash )
	lv2? ( gtk? ( dev-cpp/gtkmm:2.4 )
		dev-libs/sord
		media-libs/lilv
		media-libs/lv2 )
	osc? ( media-libs/liblo )
	realtime? ( media-libs/rtaudio )
	dev-qt/qtcore
	dev-qt/qtsvg
	dev-qt/qtwidgets
	dev-qt/qtxml
	media-libs/libsamplerate
	media-libs/libsndfile
	virtual/jack
"
RDEPEND="${DEPEND}"
BDEPEND=""

S=${WORKDIR}/${MY_PN}-${MY_PV}

src_prepare() {
	sed -i '/RPATH/d' CMakeLists.txt || die
	sed -i '/SET(MusE_/s/muse/&seq/' CMakeLists.txt || die
	cmake-utils_src_prepare
}

src_configure() {
	local my_moddir
	my_moddir="/usr/$(get_libdir)/${PN}-$(ver_cut 1).$(ver_cut 2)/modules/"
	append-cflags="-L${my_moddir}"
	append-cxxflags="-L${my_moddir}"
	append-ldflags "-Wl,-rpath=${my_moddir},--enable-new-dtags"

	# media-libs/libinstpatch not available
	local mycmakeargs=(
		-DENABLE_ALSA=$(usex alsa ON OFF)
		-DENABLE_DSSI=$(usex dssi ON OFF)
		-DENABLE_FLUID=$(usex fluidsynth ON OFF)
		-DENABLE_LASH=$(usex lash ON OFF)
		-DENABLE_LV2=$(usex lv2 ON OFF)
		-ENABLE_LV2_GTK2=$(usex lv2 $(usex gtk ON OFF) OFF)
		-DENABLE_OSC=$(usex osc ON OFF)
		-DENABLE_RTAUDIO=$(usex alsa ON OFF)
		-DENABLE_VST=$(usex vst ON OFF)
		-DENABLE_VST_NATIVE=$(usex vst ON OFF)
		-DENABLE_VST_VESTIGE=$(usex vst ON OFF)
		-DENABLE_INSTPATCH=OFF
	)
	cmake-utils_src_configure
}
