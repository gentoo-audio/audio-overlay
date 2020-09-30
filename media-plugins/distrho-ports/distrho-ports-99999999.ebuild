# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3 meson

DESCRIPTION="Linux ports of Distrho plugins."
HOMEPAGE="https://github.com/DISTRHO/DISTRHO-Ports"
EGIT_REPO_URI="https://github.com/DISTRHO/DISTRHO-Ports"
if [[ ${PV} == *9999 ]]; then
	KEYWORDS=""
else
	EGIT_COMMIT="$(ver_cut 1-2)"
	KEYWORDS="~amd64"
fi
LICENSE="GPL-2"
SLOT="0"

IUSE="lv2 vst"
REQUIRED_USE="|| ( lv2 vst )"

RDEPEND="media-libs/alsa-lib
	media-libs/freetype
	virtual/opengl
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXcursor
	x11-libs/libXrender"
DEPEND="${RDEPEND}"

src_prepare() {
	# Remove stripping of binaries
	sed -i -e "/'-Wl,--strip-all',/d" meson.build || die "sed failed"

	# Remove hardcoded O3 CFLAG
	sed -i -e "s/'-O3', //" meson.build || die "sed failed"

	default
}

src_configure() {
	local emesonargs=(
		-Doptimizations=false
		$(meson_use vst build-vst2)
		$(meson_use vst build-vst3)
		$(meson_use lv2 build-lv2)
	)
	meson_src_configure
}
