# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

WX_GTK_VER="2.8"
inherit eutils flag-o-matic wxwidgets

DESCRIPTION="Tool for creating an AC-3 (Dolby Digital) multichannel stream from its JACK input ports"
HOMEPAGE="http://essej.net/ac3jack/"
SRC_URI="http://essej.net/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="dev-libs/boost
	dev-libs/libsigc++:1.2
	>media-libs/aften-0.0.8
	media-libs/liblo
	>=media-sound/jack-audio-connection-kit-0.80.0
	>=media-video/ffmpeg-0.4.6
	x11-libs/wxGTK:2.8[X]"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-compile-fix.patch
	epatch "${FILESDIR}"/${P}-compile-fix2.patch
}

src_configure() {
	append-libs -lboost_system
	default
}

src_install(){
	default
	make_desktop_entry ${PN} AC3Jack ${PN} "AudioVideo;Audio"
}
