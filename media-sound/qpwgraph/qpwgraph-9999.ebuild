# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit xdg cmake git-r3

DESCRIPTION="Qt GUI to control the JACK Audio Connection Kit and ALSA sequencer connections"
HOMEPAGE="https://gitlab.freedesktop.org/rncbc/qpwgraph"
EGIT_REPO_URI="https://gitlab.freedesktop.org/rncbc/qpwgraph.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="alsa debug systray"

BDEPEND="virtual/pkgconfig"
DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	media-video/pipewire
	alsa? ( media-libs/alsa-lib )
	systray? ( dev-qt/qtnetwork:5 )
"
# XXX OLD
#dev-qt/qtx11extras:5
#dbus? ( dev-qt/qtdbus:5 )

#RDEPEND="${DEPEND}
#	dev-qt/qtsvg:5
#"

src_configure() {
	local mycmakeargs=(
		-DCONFIG_ALSA_MIDI=$(usex alsa 1 0)
		-DCONFIG_DEBUG=$(usex debug 1 0)
		-DCONFIG_SYSTEM_TRAY=$(usex systray 1 0)
		-DCONFIG_WAYLAND=0
		-DCONFIG_QT6=0
	)
	cmake_src_configure
}
