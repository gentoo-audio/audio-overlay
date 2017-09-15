# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit versionator autotools flag-o-matic

MY_P="${PN}-$(replace_version_separator "3" ".")"

DESCRIPTION="a simple video player that is synchronized to jack transport."
HOMEPAGE="http://xjadeo.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="alsa imlib +ipc jacksession ltc midi opengl osc osd osdfont posixmq qt4 portmidi sdl -timescale -framecrop tools xv"

REQUIRED_USE="alsa? ( midi )
	portmidi? ( midi )
	osdfont? ( osd )"

RDEPEND="virtual/jack
	>=media-video/ffmpeg-0.4.9
	x11-libs/libXpm
	media-libs/porttime
	midi? (
		alsa? ( >=media-libs/alsa-lib-1.0.10 )
		portmidi? ( media-libs/portmidi )
	)
	imlib? ( >=media-libs/imlib2-1.3.0 )
	osc? ( media-libs/liblo )
	sdl? ( >=media-libs/libsdl-1.2.8 )
	opengl? ( virtual/glu )
	osd? ( media-libs/freetype:2 )
	ltc? ( media-libs/libltc )"

DEPEND="${RDPEND}
	>=sys-libs/zlib-1.2.2
	qt4? ( dev-qt/qt3support
		>=dev-qt/qttest-4:4
	)
	virtual/pkgconfig"

PATCHES=( "${FILESDIR}/${PN}-0.8.5-no-libporttime.patch" )

DOCS=( AUTHORS ChangeLog README NEWS )

S="${WORKDIR}/${MY_P}"

src_prepare() {
	# Missed requirement, whem MQ is disabled
	use posixmq || append-libs -lpthread
	default
}

src_configure() {
	eautoreconf
	econf \
		--enable-imlib2=$(usex imlib) \
		--enable-alsamidi=$(usex alsa) \
		--enable-portmidi=$(usex portmidi) \
		--enable-midi=$(usex midi) \
		--enable-osc=$(usex osc) \
		--enable-ft=$(usex osd) \
		--enable-qtgui=$(usex qt4) \
		--enable-sdl=$(usex sdl) \
		--enable-contrib=$(usex tools) \
		--enable-xv=$(usex xv) \
		--enable-opengl=$(usex opengl) \
		--enable-jacksession=$(usex jacksession) \
		--enable-embed-font=$(usex osdfont) \
		--enable-ltc=$(usex ltc) \
		--enable-ipc=$(usex ipc) \
		--enable-mq=$(usex posixmq) \
		--enable-timescale=$(usex timescale) \
		--enable-framecrop=$(usex framecrop)
}

src_install() {
	default_src_install
	if use tools; then
		newdoc contrib/cli-remote/README README.cli-remote
		dobin contrib/cli-remote/jadeo-rcli
		insinto "/usr/share/${PN}"
		doins "contrib/${PN}-example.mp4"
	fi
}

pkg_postinst() {
    use qt4 && {
        ewarn "qjadeo is deprecated an not intended to be used."
        ewarn "It will be removed in future releases."
        ewarn "Xjadeo now features a complete built-in user interface."
    }
}

