# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools desktop xdg flag-o-matic

DESCRIPTION="Visual programming language for multimedia"
HOMEPAGE="http://msp.ucsd.edu/software.html"
if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/pure-data/${PN}.git"
	SRC_URI="https://puredata.info/portal_css/Plone%20Default/logo.png -> ${PN}.png"
	KEYWORDS=""
else
	MY_P="pd-$(ver_cut 1-2)-$(ver_cut 3-)"
	SRC_URI="http://msp.ucsd.edu/Software/pd-$(ver_cut 1-2)-$(ver_cut 3-).src.tar.gz
		https://puredata.info/portal_css/Plone%20Default/logo.png -> ${PN}.png"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${MY_P}"
fi
LICENSE="BSD"
SLOT="0"

IUSE="alsa fftw jack oss double-precision"
REQUIRED_USE="|| ( alsa jack oss )"

RDEPEND="
	dev-lang/tcl:=
	dev-lang/tk:=[truetype]
	alsa? ( media-libs/alsa-lib )
	jack? ( virtual/jack )
	fftw? ( >=sci-libs/fftw-3 )"
DEPEND="${RDEPEND}"

src_prepare() {
	default
	eautoreconf
}

# Disable portaudio and portmidi because otherwise Pd's local sources get installed
src_configure() {
	use double-precision && append-cppflags "-DPD_FLOATSIZE=64"
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
