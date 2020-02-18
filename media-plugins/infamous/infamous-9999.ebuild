# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils git-r3

DESCRIPTION="A collection of open-source LV2 plugins"
HOMEPAGE="https://ssj71.github.io/infamousPlugins"
EGIT_REPO_URI="https://github.com/ssj71/infamousPlugins"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	media-libs/lv2
	media-libs/zita-resampler
	sci-libs/fftw:3.0
	x11-libs/ntk
	x11-libs/cairo
"
RDEPEND="${DEPEND}"
BDEPEND=""

src_configure() {
	local mycmakeargs=( -DLIBDIR=$(get_libdir) )
	cmake-utils_src_configure
}
