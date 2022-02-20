# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake git-r3

DESCRIPTION="LV2 drum sampler plugin"
HOMEPAGE="http://openavproductions.com/fabla2"
EGIT_REPO_URI="https://github.com/openAVproductions/openAV-Fabla2.git"
KEYWORDS=""
LICENSE="GPL-2"
SLOT="2"

IUSE="+X"

RDEPEND="media-libs/lv2
	media-libs/libsndfile
	media-libs/libsamplerate
	X? ( x11-libs/cairo[X] )"
DEPEND="${RDEPEND}"

src_prepare() {
	# Fix hardcoded libdir
	sed -i -e "s|lib/lv2|$(get_libdir)/lv2|" CMakeLists.txt || die "sed failed"

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
	-DBUILD_GUI="$(usex X ON OFF)"
	)
	cmake_src_configure
}
