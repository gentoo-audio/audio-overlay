# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# TODO
# - What about bundled libs? Shouldn't they be removed?
# - Install docs in correct location? (currently in /opt/bitwig-studio/resources/doc)

EAPI=6

inherit eutils unpacker xdg-utils

DESCRIPTION="Multi-platform music-creation system for production, performance and DJing"
HOMEPAGE="http://bitwig.com"
SRC_URI="http://downloads.bitwig.com/${P}.deb"
LICENSE="Bitwig"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="mirror"

IUSE="+jack"

DEPEND=""
RDEPEND="${DEPEND}
	app-arch/bzip2
	dev-libs/expat
	gnome-extra/zenity
	jack? ( media-sound/jack2 )
	media-libs/alsa-lib
	media-libs/fontconfig
	media-libs/freetype
	media-libs/libpng:0/16
	media-libs/mesa
	sys-libs/zlib
	virtual/ffmpeg
	virtual/opengl
	virtual/udev
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
"

QA_PREBUILT="opt/bitwig-studio/lib/engine/*"
QA_PRESTRIPPED="
	opt/bitwig-studio/bin/BitwigPluginHost64
	opt/bitwig-studio/bin/BitwigStudioEngine
	opt/bitwig-studio/bin/bitwig-vamphost
	opt/bitwig-studio/bin32/BitwigPluginHost32
	opt/bitwig-studio/bitwig-studio
	opt/bitwig-studio/lib/bitwig-studio/libXau.so.6
	opt/bitwig-studio/lib/bitwig-studio/libXcursor.so.1
	opt/bitwig-studio/lib/bitwig-studio/libXdmcp.so.6
	opt/bitwig-studio/lib/bitwig-studio/libcairo.so.2
	opt/bitwig-studio/lib/bitwig-studio/libfreetype.so.6
	opt/bitwig-studio/lib/bitwig-studio/libharfbuzz.so.0
	opt/bitwig-studio/lib/bitwig-studio/liblwjgl.so
	opt/bitwig-studio/lib/bitwig-studio/libpng16.so.16
	opt/bitwig-studio/lib/bitwig-studio/libxcb-xkb.so.1
	opt/bitwig-studio/lib/jre/lib/amd64/libjfxwebkit.so"

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
	sed -i \
	-e 's/Icon=.*/Icon=bitwig-studio/' \
	-e 's/Categories=.*/Categories=AudioVideo;Audio;AudioVideoEditing/' \
	usr/share/applications/bitwig-studio.desktop || die 'sed on desktop file failed'
	domenu usr/share/applications/bitwig-studio.desktop
	doicon -s scalable -c mimetypes usr/share/icons/hicolor/scalable/mimetypes/*.svg
	insinto /usr/share/mime/packages
	doins usr/share/mime/packages/bitwig-studio.xml
}

pkg_postinst() {
	xdg_mimeinfo_database_update
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_mimeinfo_database_update
	xdg_desktop_database_update
}
