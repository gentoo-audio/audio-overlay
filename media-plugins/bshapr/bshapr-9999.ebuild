# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3

DESCRIPTION="Beat / envelope shaper LV2 plugin"
HOMEPAGE="https://github.com/sjaehn/BShapr"
EGIT_REPO_URI="https://github.com/sjaehn/BShapr"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="media-libs/lv2
	x11-libs/cairo
	x11-libs/libX11"
RDEPEND="${DEPEND}"
BDEPEND=""

src_prepare() {
	sed -i -e '/^PREFIX/s:/local::' \
		-e '/^LV2DIR/s/lib/&64/' makefile
	default
}
