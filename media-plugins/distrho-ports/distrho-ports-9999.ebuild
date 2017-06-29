# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# requires proaudio overlay

EAPI=5

inherit git-r3

DESCRIPTION="Linux ports of Distrho plugins."
HOMEPAGE="http://distrho.sourceforge.net"

SRC_URI=""
EGIT_BRANCH="master"
EGIT_REPO_URI="https://github.com/DISTRHO/DISTRHO-Ports.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

IUSE=""

DEPEND="virtual/jack
	media-libs/freetype
	<dev-util/premake-4.3"

RDEPEND=${DEPEND}

src_prepare() {
	"${WORKDIR}"/"${P}"/scripts/premake-update.sh linux
}

src_compile() {
	emake
}

src_install() {
	emake DESTDIR="${D}" install
}
