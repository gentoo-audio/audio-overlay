# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# TODO
# - Verify all runtime dependencies, min versions, and required flags
# - Avoid bundled JRE?
# - What about bundled libs? Shouldn't they be removed?
# - Install docs in correct location? (currently in /opt/bitwig-studio/resources/doc)

EAPI=6
inherit eutils fdo-mime unpacker

DESCRIPTION="for creation and performance of your musical ideas on stage or in the studio."
HOMEPAGE="http://bitwig.com"
SRC_URI="http://downloads.bitwig.com/${P}.deb"
LICENSE="Bitwig"
SLOT="1"
KEYWORDS="~amd64"
RESTRICT="mirror strip"

IUSE="jack libav"

DEPEND=""
RDEPEND="${DEPEND}
	app-arch/bzip2
	dev-libs/expat
	gnome-extra/zenity
	media-libs/alsa-lib
	media-libs/fontconfig
	media-libs/freetype
	media-libs/libpng:0/16
	media-libs/mesa
	sys-libs/zlib
	x11-libs/cairo[xcb]
	x11-libs/libX11
	x11-libs/libXau
	x11-libs/libXcursor
	x11-libs/libXdmcp
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXrender
	x11-libs/libdrm
	x11-libs/libxcb
	x11-libs/libxkbfile
	x11-libs/pixman
	x11-libs/xcb-util-wm
	virtual/opengl
	virtual/udev
	jack? ( virtual/jack )
	libav? ( media-video/libav )"

QA_PREBUILT="opt/bitwig-studio/lib/engine/*"

S=${WORKDIR}

src_install() {
	BITWIG_HOME="/opt/bitwig-studio"
	dodir ${BITWIG_HOME}
	insinto ${BITWIG_HOME}
	doins -r opt/bitwig-studio/*
	fperms +x ${BITWIG_HOME}/bitwig-studio
	fperms +x ${BITWIG_HOME}/bin/BitwigPluginHost64
	fperms +x ${BITWIG_HOME}/bin/BitwigStudioEngine
	fperms +x ${BITWIG_HOME}/bin/bitwig-vamphost
	fperms +x ${BITWIG_HOME}/bin/show-splash-gtk
	fperms +x ${BITWIG_HOME}/bin32/BitwigPluginHost32
	dosym ${BITWIG_HOME}/bitwig-studio /usr/bin/bitwig-studio

	doicon -s scalable usr/share/icons/hicolor/scalable/apps/bitwig-studio.svg
	make_desktop_entry ${PN} "Bitwig Studio" "" "" "MimeType=application/bitwig-project;application/bitwig-template"

	doicon -s scalable -c mimetypes usr/share/icons/hicolor/scalable/mimetypes/*.svg
	insinto /usr/share/mime/packages
	doins usr/share/mime/packages/bitwig-studio.xml
}

pkg_postinst() {
	fdo-mime_mime_database_update
	fdo-mime_desktop_database_update

	if ! use libav; then
		einfo "libav USE flag not set. Bitwig Studio requires the avprobe and avconv tools"
		einfo "for importing audio files."
	fi
}

pkg_postrm() {
	fdo-mime_mime_database_update
	fdo-mime_desktop_database_update
}
