# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit git-r3

DESCRIPTION="Capture audio-data from JACK and write it to standard-output"
HOMEPAGE="http://rg42.org/gitweb/?p=jack-stdout.git;a=summary https://github.com/x42/jack-stdio"
EGIT_REPO_URI="https://github.com/x42/jack-stdio.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""
DEPEND="media-sound/jack-audio-connection-kit"
RDEPEND="${DEPEND}"

src_prepare() {
	default
	epatch ${FILESDIR}/jack-stdio-9999-custom-cflags.patch
}

src_configure() {
	return
	# Doesn't use configure
}

src_install() {
	export PREFIX=/usr
	default
	dodoc COPYING
}
