# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A portable Fasttracker II clone using SDL"
HOMEPAGE="https://16-bits.org/ft2.php"
SRC_URI="https://16-bits.org/${PN}-v${PV}-code.zip"

LICENSE="BSD-with-disclosure"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="media-libs/alsa-lib
	media-libs/libsdl2"
RDEPEND="${DEPEND}"
BDEPEND=""

S=${WORKDIR}/${PN}-code

src_compile() {
	gcc -D__LINUX_ALSA__ src/rtmidi/*.cpp src/gfxdata/*.c src/*.c -lSDL2 -lpthread -lasound -lstdc++ -lm ${CFLAGS} -o ft2-clone
}

src_install() {
	dobin ft2-clone
}
