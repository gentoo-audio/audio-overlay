# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3

DESCRIPTION="A simple sound generator to have some fun with"
HOMEPAGE="https://github.com/brummer10/Xmonk.lv2"
EGIT_REPO_URI="https://github.com/brummer10/Xmonk.lv2"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="x11-libs/cairo
		x11-libs/libX11"
RDEPEND="${DEPEND}"
BDEPEND=""

src_prepare() {
	sed -i -e '/INSTALL_DIR/s/lib/&64/' \
		-e '/STRIP/d' Xmonk/Makefile || die
	default
}
