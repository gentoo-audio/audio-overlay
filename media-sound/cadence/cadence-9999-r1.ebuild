# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3

DESCRIPTION="Collection of tools useful for audio production"
HOMEPAGE="http://kxstudio.linuxaudio.org"
EGIT_REPO_URI="https://github.com/falkTX/Cadence.git"
KEYWORDS=""
LICENSE="GPL-2"
SLOT="0"

IUSE="-pulseaudio a2jmidid"

RDEPEND="virtual/jack
	dev-python/PyQt4[X,svg]
	dev-python/dbus-python
	>=media-sound/ladish-9999
	a2jmidid? ( media-sound/a2jmidid )
	pulseaudio? ( media-sound/pulseaudio[jack] )"
DEPEND=${RDEPEND}

PATCHES=( "${FILESDIR}"/${PN}-add-skip-stripping.patch )

src_compile() {
	myemakeargs=(PREFIX="/usr"
		SKIP_STRIPPING=true
	)
	emake "${myemakeargs[@]}"
}

src_install() {
	emake PREFIX="/usr" DESTDIR="${D}" install

	# Clean up stuff that shouldn't be installed
	rm -rf "${D}/usr/share/cadence/src"
	rm -rf "${D}/etc/X11/xinit/xinitrc.d/61cadence-session-inject"
	rm -rf "${D}/etc/xdg/autostart/cadence-session-start.desktop"
	if use !pulseaudio; then
		rm -rf "${D}/usr/share/cadence/pulse2jack"
		rm -rf "${D}/usr/share/cadence/pulse2loopback"
	fi
}
