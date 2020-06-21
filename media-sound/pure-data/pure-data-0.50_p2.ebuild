# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools eutils xdg-utils

DESCRIPTION="Visual programming language for multimedia"
HOMEPAGE="http://msp.ucsd.edu/software.html"
if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/pure-data/${PN}.git"
	KEYWORDS=""
else
	MY_PN="pd"
	MY_PV=${PV/_p/-}
	MY_P="${MY_PN}-${MY_PV}"
	SRC_URI="http://msp.ucsd.edu/Software/${MY_P}.src.tar.gz
		https://puredata.info/portal_css/Plone%20Default/logo.png -> ${PN}.png"
	KEYWORDS="~amd64"
fi
LICENSE="BSD"
SLOT="0"

IUSE="alsa fftw jack oss"
REQUIRED_USE="|| ( alsa jack oss )"

RDEPEND="
	dev-lang/tcl:=
	dev-lang/tk:=[truetype]
	alsa? ( media-libs/alsa-lib )
	jack? ( virtual/jack )
	fftw? ( >=sci-libs/fftw-3 )"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	default
	eautoreconf
}

# Disable portaudio and portmidi because otherwise Pd's local sources get installed
src_configure() {
	econf --disable-portaudio \
		--without-local-portaudio \
		--disable-portmidi \
		--without-local-portmidi \
		$(use_enable alsa) \
		$(use_enable jack) \
		$(use_enable fftw) \
		$(use_enable oss)
}

src_install() {
	default

	doicon -s 48 "${DISTDIR}"/${PN}.png
	make_desktop_entry pd "pure data" "${PN}" "AudioVideo;AudioVideoEditing"
}

pkg_postinst() {
	xdg_mimeinfo_database_update
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_mimeinfo_database_update
	xdg_icon_cache_update
}
