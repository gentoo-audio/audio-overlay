# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Polyphonic wavetable synth LV2 plugin"
HOMEPAGE="http://openavproductions.com/sorcer"
if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/openAVproductions/openAV-Sorcer.git"
	KEYWORDS=""
else
	SRC_URI="https://github.com/openAVproductions/openAV-Sorcer/archive/release-${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
	S="${WORKDIR}/openAV-Sorcer-release-${PV}"
fi
LICENSE="GPL-2"
SLOT="0"

IUSE=""
REQUIRED_USE=""

RDEPEND="media-libs/lv2
	dev-libs/boost
	>=x11-libs/ntk-1.3.1000"
DEPEND="${RDEPEND}"

PATCHES="${FILESDIR}/${PN}-gcc-9-remove-leading-underscore.patch"

src_prepare() {
	# Fix hardcoded libdir
	sed -i -e "s|lib/lv2|$(get_libdir)/lv2|" CMakeLists.txt || die "sed failed"

	cmake_src_prepare
}
