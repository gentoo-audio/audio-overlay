# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

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
fi
LICENSE="GPL-2"
SLOT="1"

IUSE=""

RDEPEND="media-libs/lv2
	media-libs/libsndfile
	>=x11-libs/ntk-1.3.1000
	media-libs/mesa"
DEPEND="${RDEPEND}"
