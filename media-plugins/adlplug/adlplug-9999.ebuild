# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils multibuild git-r3

DESCRIPTION="FM synthesizer plugins based on OPL3 and OPN2 sound chip emulations"
HOMEPAGE="https://github.com/jpcima/ADLplug"

EGIT_REPO_URI="https://github.com/jpcima/${PN}.git"
if [[ ${PV} == *9999 ]]; then
	KEYWORDS=""
else
	# Upstream release tarballs do not contain the necessary third party libs;
	# these are available via git submodules per upstream build instructions
	EGIT_COMMIT="v${PV}"
	KEYWORDS="~amd64"
fi

LICENSE="Boost-1.0 BSD GPL-3 GPL-2+ LGPL-3 LGPL-2.1 MIT ISC"
SLOT="0"

# Upstream offers a VST3 build option, but unfortunately JUCE 5.4.1
# doesn't support VST3 on Linux
# see https://github.com/WeAreROLI/JUCE/issues/307
IUSE="+opl3 +opn2 +lv2 +vst jack alsa pch assertions"
REQUIRED_USE="
	|| ( opl3 opn2 )
	|| ( lv2 vst jack alsa )
"

# JUCE will stop the build if alsa-lib is not present, regardless
# of the build options
DEPEND="
	x11-libs/libXinerama
	x11-libs/libXext
	x11-libs/libXrandr
	x11-libs/libXcursor
	media-libs/freetype
	media-libs/alsa-lib
	jack? ( virtual/jack )
"
RDEPEND="${DEPEND}"
BDEPEND="
	dev-util/cmake
	|| (
		>=sys-devel/gcc-4.8.1
		>=sys-devel/clang-3.3
	)
"

src_prepare() {
	MULTIBUILD_VARIANTS=()
	use opl3 && MULTIBUILD_VARIANTS+=( opl3 )
	use opn2 && MULTIBUILD_VARIANTS+=( opn2 )

	CMAKE_USE_DIR=${WORKDIR}/${P}
	BUILD_DIR=${CMAKE_USE_DIR}/build

	# see https://github.com/jpcima/ensemble-chorus/issues/10
	cd ${CMAKE_USE_DIR}/thirdparty/JUCE
	eapply "${FILESDIR}/gcc9_juce_fix.patch"
	cd ${CMAKE_USE_DIR}

	# Upstream build overwrites ALSA standalone binary with JACK
	# standalone binary during install if both are enabled
	# This patch installs the ALSA standalones as [name]-alsa
	if use jack && use alsa ; then
		eapply "${FILESDIR}/jack_and_alsa_standalones.patch"
	fi

	cmake-utils_src_prepare
}

adl_configure() {
	CMAKE_BUILD_TYPE="Release"
	local adl_prefix="ADLplug_"
	local mycmakeargs=(
		"-D${adl_prefix}CHIP=${MULTIBUILD_VARIANT^^}"
		"-D${adl_prefix}LV2=$(usex lv2)"
		"-D${adl_prefix}VST2=$(usex vst)"
		"-D${adl_prefix}Standalone=$(usex alsa)"
		"-D${adl_prefix}Jack=$(usex jack)"
		"-D${adl_prefix}PCH=$(usex pch)"
		"-D${adl_prefix}ASSERTIONS=$(usex assertions)"
	)

	cmake-utils_src_configure
}

src_configure() {
	multibuild_foreach_variant adl_configure
}

src_compile() {
	multibuild_foreach_variant cmake-utils_src_compile
}

src_test() {
	multibuild_foreach_variant cmake-utils_src_test
}

src_install() {
	multibuild_foreach_variant cmake-utils_src_install
}

pkg_postinst() {
	if use jack && use alsa ; then
		if use opl3 ; then
			elog "The ADLplug ALSA standalone has been installed as ADLplug-alsa."
		fi
		if use opn2 ; then
			elog "The OPNplug ALSA standalone has been installed as OPNplug-alsa."
		fi
	fi

	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
