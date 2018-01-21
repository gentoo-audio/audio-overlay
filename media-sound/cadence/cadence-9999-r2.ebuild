# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{4,5,6} )
inherit git-r3 python-single-r1 gnome2-utils

DESCRIPTION="Collection of tools useful for audio production"
HOMEPAGE="http://kxstudio.linuxaudio.org"
EGIT_REPO_URI="https://github.com/falkTX/Cadence.git"
KEYWORDS=""
LICENSE="GPL-2"
SLOT="0"

IUSE="-pulseaudio a2jmidid ladish"

RDEPEND="virtual/jack
	dev-python/PyQt4[X,svg,${PYTHON_USEDEP}]
	dev-python/dbus-python
	a2jmidid? ( media-sound/a2jmidid )
	ladish? ( >=media-sound/ladish-9999 )
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
	rm -rf "${D}/etc/X11/xinit/xinitrc.d/61cadence-session-inject"
	rm -rf "${D}/etc/xdg/autostart/cadence-session-start.desktop"
	rm -rf "${D}/usr/share/applications/catarina.desktop"
	rm -rf "${D}/usr/bin/catarina"
	if use !pulseaudio; then
		rm -rf "${D}/usr/bin/cadence-pulse2jack"
		rm -rf "${D}/usr/bin/cadence-pulse2loopback"
		rm -rf "${D}/usr/share/cadence/pulse2jack"
		rm -rf "${D}/usr/share/cadence/pulse2loopback"
	fi
	if use !ladish; then
		rm -rf "${D}/usr/bin/claudia-launcher"
		rm -rf "${D}/usr/bin/claudia"
		rm -rf "${D}/usr/share/cadence/icons/claudia-hicolor/"
		rm -rf "${D}/usr/share/applications/claudia.desktop"
		rm -rf "${D}/usr/share/applications/claudia-launcher.desktop"
	fi
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
