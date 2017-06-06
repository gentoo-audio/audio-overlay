# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils

DESCRIPTION="A free polyphonic synth with lots of modulation"
HOMEPAGE="http://tytel.org/helm/"
LICENSE="GPL-3+ CC-BY-3.0"
if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/mtytel/helm.git"
	KEYWORDS=""
else
	SRC_URI="https://github.com/mtytel/helm/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi
SLOT="0"

IUSE="standalone lv2 vst"
REQUIRED_USE="|| ( standalone lv2 vst )"

RDEPEND="media-libs/alsa-lib
	media-libs/freetype
	net-misc/curl
	x11-libs/libX11
	x11-libs/libXcursor
	x11-libs/libXext
	x11-libs/libXinerama
	virtual/opengl
	lv2? ( media-libs/lv2 )
	standalone? ( virtual/jack )
"
DEPEND="${RDEPEND}"

DOCS="README.md"

src_compile() {
	if use standalone; then
		emake standalone
	fi
	if use lv2; then
		emake lv2
	fi
	if use vst; then
		emake vst
	fi
}

src_install() {
	if use standalone; then
		emake DESTDIR="${D}" install_standalone
	fi
	if use lv2; then
		emake DESTDIR="${D}" install_lv2
	fi
	if use vst; then
		emake DESTDIR="${D}" install_vst
	fi
}
