# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3

DESCRIPTION="Plugin synth closely modeled on Yamaha DX7"
HOMEPAGE="https://asb2m10.github.io/dexed/"
EGIT_REPO_URI="https://github.com/asb2m10/dexed"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="alsa vst"

DEPEND="
	alsa? ( media-libs/alsa-lib )
	net-misc/curl
	media-libs/freeglut
	virtual/jack
	"
RDEPEND="${DEPEND}"
BDEPEND=""

#PATCHES=( ${FILESDIR}/${P}-gcc9.patch )

src_prepare() {
	sed -i -e '/JUCE_TARGET/s/Dexed/dexed/g' Builds/Linux/Makefile
	default
}

src_configure() {
	emake "JUSE_ALSA=$(usex alsa 1 0)" -C Builds/Linux Standalone
	use vst && emake "JUCE_ALSA=0" -C Builds/Linux VST
}

src_install() {
	dobin Builds/Linux/build/dexed
	use vst && dolib.so Builds/Linux/build/dexed.so
}
