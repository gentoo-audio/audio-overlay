# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="6"

[[ "${PV}" = "9999" ]] && inherit git-r3

PYTHON_COMPAT=( python{2_7,3_{4,5,6}} )
PYTHON_REQ_USE="threads(+)"
inherit python-any-r1 waf-utils

DESCRIPTION="A simple Linux Guitar Amplifier for jack with one input and two outputs"
HOMEPAGE="http://guitarix.sourceforge.net/"

RESTRICT="mirror"
if [ "${PV}" = "9999" ]; then
	EGIT_REPO_URI="https://git.code.sf.net/p/guitarix/git/"
	S="${S}/trunk"
	KEYWORDS=""
else
	SRC_URI="mirror://sourceforge/guitarix/guitarix/${P}.tar.xz"
	S="${WORKDIR}/guitarix-${PV}"
	KEYWORDS="~amd64 ~x86"
fi

SLOT="0"
LICENSE="GPL-3"

IUSE="avahi bluetooth +capture debug faust ladspa lv2 +meterbridge nls profile python sse"

RDEPEND="dev-cpp/eigen:3
	dev-cpp/glibmm:2
	dev-cpp/gtkmm:2.4
	dev-libs/boost
	dev-libs/glib
	media-fonts/roboto
	media-libs/liblrdf
	media-libs/libsndfile
	media-libs/lilv:0
	media-libs/zita-convolver
	media-libs/zita-resampler
	virtual/jack
	media-sound/lame
	sci-libs/fftw:3.0
	x11-libs/gtk+:2
	python? ( dev-python/pygobject:2 )
	avahi? ( net-dns/avahi[utils] )
	faust? ( dev-lang/faust )
	ladspa? ( media-libs/ladspa-sdk )
	lv2? ( || ( media-libs/lv2core media-libs/lv2 ) )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	nls? ( dev-util/intltool )"
RDEPEND="${RDEPEND}
	capture? ( media-sound/jack_capture )
	meterbridge? ( media-sound/meterbridge )"

DOCS=( changelog README README.developers )

src_unpack() {
	[[ "${PV}" = "9999" ]] && git-r3_src_unpack || default
}

src_configure() {
	mywafconfargs=(
		--cxxflags-debug=""
		--cxxflags-release="-DNDEBUG"
		--nocache
		--shared-lib
		--lib-dev
		--no-ldconfig
		--no-desktop-update
		#--glade-support   # FIXME: fails to build with this option
		$(usex nls --enable-nls '')
		$(usex avahi '' --no-avahi)
		$(usex bluetooth '' --no-bluez)
		$(usex debug --debug '')
		$(usex faust --faust --no-faust)
		$(usex ladspa --ladspadir="${EPREFIX}"/usr/share/ladspa '--no-ladspa --no-new-ladspa')
		$(usex lv2 --lv2dir="${EPREFIX}"/usr/$(get_libdir)/lv2 --no-lv2)
		$(usex profile --with-gcov '')
		$(usex python --python-wrapper '')
		$(usex sse '' --disable-sse)
	)
	waf-utils_src_configure ${mywafconfargs[@]}
}
