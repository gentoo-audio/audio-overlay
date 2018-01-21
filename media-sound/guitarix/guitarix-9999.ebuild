# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="threads(+)"

inherit python-any-r1 waf-utils

DESCRIPTION="A simple Linux Guitar Amplifier for jack with one input and two outputs"
HOMEPAGE="http://guitarix.sourceforge.net/"
if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://git.code.sf.net/p/guitarix/git"
	EGIT_SUBMODULES=()
	KEYWORDS=""
	S="${S}/trunk"
else
	SRC_URI="mirror://sourceforge/guitarix/guitarix/${PN}2-${PV}.tar.xz"
	KEYWORDS="~amd64"
	S="${WORKDIR}/guitarix-${PV}"
fi
LICENSE="GPL-2"
SLOT="0"

# Enabling LADSPA is discouraged by the developer
# See https://linuxmusicians.com/viewtopic.php?p=88153#p88153
IUSE="+standalone -ladspa +lv2 avahi bluetooth nls"
# When enabling LADSPA, standalone is required because the LADSPA build
# dependencies aren't correctly defined
REQUIRED_USE="|| ( standalone lv2 ladspa )
	ladspa? ( standalone )"

RDEPEND="media-libs/libsndfile
	x11-libs/gtk+:2
	virtual/jack
	dev-cpp/gtkmm:2.4
	dev-libs/boost
	dev-cpp/eigen:3
	sci-libs/fftw:3.0
	>=media-libs/zita-convolver-3
	media-libs/zita-resampler
	standalone? (
		media-libs/lilv
		media-libs/liblrdf
		media-fonts/roboto
	)
	ladspa? ( media-libs/ladspa-sdk )
	lv2? ( media-libs/lv2 )
	avahi? ( net-dns/avahi )
	bluetooth? ( net-wireless/bluez )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	nls? ( dev-util/intltool )"

DOCS=( changelog README )

src_configure() {
	local mywafconfargs=(
		--cxxflags-release="-DNDEBUG"
		--nocache
		--shared-lib
		--lib-dev
		--no-ldconfig
		--no-desktop-update
		--no-faust
		$(usex standalone "" "--no-standalone")
		$(usex ladspa "--ladspa --new-ladspa" "")
		$(usex lv2 "" "--no-lv2")
		$(usex avahi "" "--no-avahi")
		$(usex bluetooth "" "--no-bluez")
		$(usex nls "--enable-nls" "--disable-nls")
	)
	waf-utils_src_configure ${mywafconfargs[@]}
}
