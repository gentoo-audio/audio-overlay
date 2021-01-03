# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop unpacker xdg

DESCRIPTION="Multi-platform music-creation system for production, performance and DJing"
HOMEPAGE="http://bitwig.com"
SRC_URI="https://downloads.bitwig.com/stable/${PV}/${P}.deb"
LICENSE="Bitwig"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="mirror"

IUSE="abi_x86_32 +jack cpu_flags_x86_sse4_1"
REQUIRED_USE="cpu_flags_x86_sse4_1"

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
	media-video/ffmpeg
	virtual/opengl
	virtual/udev
	x11-libs/cairo[X]
	x11-libs/gtk+:3
	x11-libs/libX11[abi_x86_32?]
	x11-libs/libXau[abi_x86_32?]
	x11-libs/libXcursor
	x11-libs/libXdmcp[abi_x86_32?]
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXrender
	x11-libs/libdrm
	x11-libs/libxcb[abi_x86_32?]
	x11-libs/libxkbcommon[X,abi_x86_32?]
	x11-libs/libxkbfile
	x11-libs/pixman
	x11-libs/xcb-util[abi_x86_32?]
	x11-libs/xcb-util-wm[abi_x86_32?]
	x11-libs/libXtst
"

QA_PRESTRIPPED="
	opt/bitwig-studio/bitwig-studio
	opt/bitwig-studio/bin/.*
	opt/bitwig-studio/bin32/BitwigPluginHost32
	opt/bitwig-studio/lib/bitwig-studio/.*
	opt/bitwig-studio/lib/vamp-plugins/.*
"

S=${WORKDIR}

src_install() {
	BITWIG_HOME="/opt/bitwig-studio"
	dodir ${BITWIG_HOME}
	insinto ${BITWIG_HOME}
	doins -r opt/bitwig-studio/*
	fperms +x ${BITWIG_HOME}/bitwig-studio
	fperms +x ${BITWIG_HOME}/bin/BitwigPluginHost64
	fperms +x ${BITWIG_HOME}/bin/BitwigStudio
	fperms +x ${BITWIG_HOME}/bin/BitwigStudioEngine
	fperms +x ${BITWIG_HOME}/bin/BitwigStudioEngineAVX2
	fperms +x ${BITWIG_HOME}/bin/BitwigVampHost
	fperms +x ${BITWIG_HOME}/bin/show-file-dialog-gtk3
	fperms +x ${BITWIG_HOME}/bin/show-splash-gtk
	dosym ${BITWIG_HOME}/bitwig-studio /usr/bin/bitwig-studio

	if use abi_x86_32; then
		fperms +x ${BITWIG_HOME}/bin32/BitwigPluginHost32
	else
		rm -rf "${ED}/${BITWIG_HOME}/bin32/"
	fi

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
