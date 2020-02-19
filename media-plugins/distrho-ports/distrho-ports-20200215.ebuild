# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3

DESCRIPTION="Linux ports of Distrho plugins."
HOMEPAGE="https://github.com/DISTRHO/DISTRHO-Ports"
EGIT_REPO_URI="https://github.com/DISTRHO/DISTRHO-Ports"
if [[ ${PV} == *9999 ]]; then
	KEYWORDS=""
else
	EGIT_COMMIT="65c7c68a79e532d01695466f5b94c0e1cc4ae940"
	KEYWORDS="~amd64"
fi
LICENSE="GPL-2"
SLOT="0"

IUSE="lv2 vst"
REQUIRED_USE="|| ( lv2 vst )"

RDEPEND="media-libs/alsa-lib
	media-libs/freetype
	media-libs/ladspa-sdk
	virtual/opengl
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXcursor
	x11-libs/libXrender"
DEPEND="${RDEPEND}
	dev-util/premake:3"

QA_PRESTRIPPED="
	/usr/lib/lv2/.*
	/usr/lib/vst/.*
"

src_prepare() {
	default
	scripts/premake-update.sh linux
}

src_compile() {
	if use lv2; then
		emake lv2
	fi
	if use vst; then
		emake vst
	fi
}

src_install() {
	emake DESTDIR="${D}" PREFIX="/usr" install
	if use !lv2; then
		rm -rf "${D}"/usr/lib/lv2
	fi
	if use !vst; then
		rm -rf "${D}"/usr/lib/vst
	fi
	rm -rf "${D}"/usr/src
}
