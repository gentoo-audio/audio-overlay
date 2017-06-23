# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
inherit toolchain-funcs multilib

DESCRIPTION="MIDI controlled DSP tonewheel organ"
HOMEPAGE="http://setbfree.org"

if [ "${PV}" = "9999" ]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/pantherb/setBfree.git"
	KEYWORDS=""
else
	SRC_URI="https://github.com/pantherb/setBfree/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
	S="${WORKDIR}/setBfree-${PV}"
fi

LICENSE="GPL-2+"
SLOT="0"
IUSE="convolution"

RDEPEND="virtual/jack
	>=media-libs/alsa-lib-1.0.0:=
	media-libs/liblo:=
	media-libs/lv2
	convolution? ( media-libs/libsndfile:=
		>=media-libs/zita-convolver-3.1.0:= )
	media-fonts/dejavu"
DEPEND="${RDEPEND}
	sys-apps/help2man
	virtual/pkgconfig"

DOCS=(ChangeLog README.md)

src_compile() {
	tc-export CC CXX
	emake $(usex convolution "ENABLE_CONVOLUTION=yes" "") \
		PREFIX="${EPREFIX}"/usr VERSION="${PV}" STRIP=true \
		FONTFILE="/usr/share/fonts/dejavu/DejaVuSans-Bold.ttf"
}

src_install() {
	emake $(usex convolution "ENABLE_CONVOLUTION=yes" "") \
		DESTDIR="${D}" PREFIX="${EPREFIX}"/usr LIBDIR="$(get_libdir)" \
		FONTFILE="/usr/share/fonts/dejavu/DejaVuSans-Bold.ttf" \
		install

	doman doc/*.1

	insinto /usr/share/pixmaps
	doins doc/setBfree.png
}
