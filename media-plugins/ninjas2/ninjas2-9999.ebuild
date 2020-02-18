# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3

DESCRIPTION="Clearly Broken Sample Slicer"
HOMEPAGE="https://github.com/rghvdberg/ninjas2"
EGIT_REPO_URI="https://github.com/rghvdberg/ninjas2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	virtual/opengl
	x11-libs/libX11
	media-libs/aubio
	media-libs/libsndfile
	media-libs/libsamplerate
"
RDEPEND="${DEPEND}"
BDEPEND=""

src_compile() {
	emake \
		USE_SYSTEM_AUBIO="true" \
		SKIP_STRIPPING="true"
}

src_install() {
	dobin bin/${PN}
	dodoc AUTHORS README.md
	insinto /usr/$(get_libdir)/lv2
	doins -r bin/${PN}.lv2
}
