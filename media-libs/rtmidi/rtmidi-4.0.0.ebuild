# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Crossplatform API for realtime MIDI I/O"
HOMEPAGE="https://www.music.mcgill.ca/~gary/rtmidi/"
SRC_URI="https://www.music.mcgill.ca/~gary/rtmidi/release/rtmidi-4.0.0.tar.gz"

LICENSE="MIT-with-advertising"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa jack"

DEPEND="alsa? ( media-libs/alsa-lib )
	jack? ( virtual/jack )"
RDEPEND="${DEPEND}"
BDEPEND=""

src_configure() {
	econf --enable-static=no \
		--with-alsa=$(usex alsa) \
		--with-jack=$(usex jack)
}
