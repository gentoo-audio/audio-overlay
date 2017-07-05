# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3

DESCRIPTION="Linux ports of Distrho plugins."
HOMEPAGE="http://distrho.sourceforge.net"

EGIT_BRANCH="master"
EGIT_REPO_URI="https://github.com/DISTRHO/DISTRHO-Ports.git"

LICENSE="GPL-2"
SLOT="0"

IUSE="+alsa +jack"

RDEPEND="alsa? ( media-libs/alsa-lib )
        jack? ( virtual/jack )"
DEPEND="${RDEPEND}
	media-libs/ladspa-sdk
        media-libs/freetype
        dev-util/premake:3
	x11-libs/libX11"

src_prepare() {
        default
        scripts/premake-update.sh linux
}
