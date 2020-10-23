# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="LV2 drum sampler plugin"
HOMEPAGE="http://openavproductions.com/fabla"
if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/openAVproductions/openAV-Fabla.git"
	KEYWORDS=""
else
	SRC_URI="https://github.com/openAVproductions/openAV-Fabla/archive/release-${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
	S="${WORKDIR}/openAV-Fabla-release-${PV}"
	RESTRICT="mirror"
fi
LICENSE="GPL-2"
SLOT="1"

IUSE=""

RDEPEND="media-libs/lv2
	media-libs/libsndfile
	>=x11-libs/ntk-1.3.1000
	media-libs/mesa"
DEPEND="${RDEPEND}"

PATCHES="${FILESDIR}/${PN}-1-gcc-9-remove-leading-underscore.patch"

src_prepare() {
	# Fix hardcoded libdir
	sed -i -e "s|lib/lv2|$(get_libdir)/lv2|" CMakeLists.txt || die "sed failed"

	cmake_src_prepare
}
