# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE='threads(+)'

inherit git-r3 python-any-r1 waf-utils

DESCRIPTION="A polyphonic virtual analogue synthesizer plugin."
HOMEPAGE="https://github.com/thunderox/triceratops"
EGIT_REPO_URI="https://github.com/thunderox/triceratops"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	dev-cpp/gtkmm:2.4
	media-libs/lv2
"
RDEPEND="${DEPEND}"
BDEPEND=""

src_configure() {
	waf-utils_src_configure
}

src_install() {
	DESTDIR="${D}" waf-utils_src_install
}
