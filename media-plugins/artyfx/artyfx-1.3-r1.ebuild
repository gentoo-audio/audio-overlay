# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Plugin bundle of artistic real-time audio effects"
HOMEPAGE="http://openavproductions.com/artyfx"
if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/openAVproductions/openAV-ArtyFX.git"
	KEYWORDS=""
else
	SRC_URI="https://github.com/openAVproductions/openAV-ArtyFX/archive/release-${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
	S="${WORKDIR}/openAV-ArtyFX-release-${PV}"
fi
LICENSE="GPL-2"
SLOT="0"

IUSE="+X cpu_flags_x86_sse"

RDEPEND="media-libs/lv2
	media-libs/libsndfile
	X? ( x11-libs/cairo[X] )"
DEPEND="${RDEPEND}"

PATCHES="${FILESDIR}/${P}-lv2-compilation-fixes.patch"

src_prepare() {
	# Fix hardcoded libdir
	sed -i -e "s|lib/lv2|$(get_libdir)/lv2|" CMakeLists.txt || die "sed failed"

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
	-DRELEASE_BUILD=ON
	-DBUILD_GUI="$(usex X ON OFF)"
	-DBUILD_SSE="$(usex cpu_flags_x86_sse ON OFF)"
	-DBUILD_BENCH=OFF
	)
	cmake_src_configure
}
