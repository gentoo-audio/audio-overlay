# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

DESCRIPTION="Live performance looping tool"
HOMEPAGE="http://openavproductions.com/luppp"
if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/openAVproductions/openAV-Luppp.git"
	KEYWORDS=""
else
	SRC_URI="https://github.com/openAVproductions/openAV-Luppp/archive/release-${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
	S="${WORKDIR}/openAV-Luppp-release-${PV}"
fi
LICENSE="GPL-3"
SLOT="0"

RDEPEND="virtual/jack
	media-libs/liblo
	>=x11-libs/ntk-1.3.1000
	media-libs/lv2
	x11-libs/cairo[X]
	media-libs/libsndfile
	media-libs/libsamplerate"
DEPEND="${RDEPEND}"
