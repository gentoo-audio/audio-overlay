# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson flag-o-matic

DESCRIPTION="A tool to assist music production by grouping standalone programs into sessions"
HOMEPAGE="https://github.com/linuxaudio/new-session-manager"
if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/linuxaudio/new-session-manager.git"
	KEYWORDS=""
else
	SRC_URI="https://github.com/linuxaudio/new-session-manager/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	RESTRICT="mirror"
	KEYWORDS="~amd64"
fi
LICENSE="GPL-3"
SLOT="0"

IUSE="gui jack"

RDEPEND="
	media-libs/liblo
	gui? ( x11-libs/fltk )
	jack? ( virtual/jack )"
DEPEND=${RDEPEND}

src_configure() {
	if use gui; then
		append-cppflags -I"$(fltk-config --includedir)"
		append-ldflags -L"$(dirname $(fltk-config --libs))"
	fi

	local emesonargs=(
		$(meson_use gui new-session-manager)
		$(meson_use gui nsm-proxy)
		$(meson_use jack jackpatch)
	)
	meson_src_configure
}
