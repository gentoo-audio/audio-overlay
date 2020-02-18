# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_6 )
PYTHON_REQ_USE='threads(+)'

inherit git-r3 python-any-r1 waf-utils

DESCRIPTION="Advanced audio plugin host"
HOMEPAGE="https://github.com/kushview/element"
EGIT_REPO_URI="https://github.com/kushview/element"
EGIT_SUBMODULES=( "*" "-modules/kv_ffmpeg/ffmpeg" )

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	media-libs/alsa-lib
	media-libs/lilv
	media-libs/lv2
	media-libs/suil
	net-misc/curl
	virtual/jack
	x11-libs/gtk+:2
"
RDEPEND="${DEPEND}"
BDEPEND=""

src_configure() {
	waf-utils_src_configure
}

src_install() {
	DESTDIR="${D}" waf-utils_src_install
}
