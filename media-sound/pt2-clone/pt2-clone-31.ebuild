# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A portable Protracker 2 clone using SDL"
HOMEPAGE="https://16-bits.org/pt2.php"
SRC_URI="https://16-bits.org/${PN}-b${PV}-code.zip"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="media-libs/alsa-lib
	media-libs/libsdl2"
RDEPEND="${DEPEND}"
BDEPEND=""

S=${WORKDIR}/${PN}-code

src_compile() {
	gcc src/gfx/*.c src/*.c -lSDL2 -lm ${CFLAGS} -o pt2-clone
}

src_install() {
	dobin pt2-clone
}
