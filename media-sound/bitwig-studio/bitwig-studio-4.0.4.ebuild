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
	opt/bitwig-studio/lib/cp/.*
"

S=${WORKDIR}

src_install() {
	BITWIG_HOME="/opt/bitwig-studio"
	dodir ${BITWIG_HOME}
	insinto ${BITWIG_HOME}
	doins -r opt/bitwig-studio/*
	fperms +x ${BITWIG_HOME}/bitwig-studio
	fperms +x ${BITWIG_HOME}/bin/BitwigPluginHost-X64-SSE41
	fperms +x ${BITWIG_HOME}/bin/BitwigStudio
	fperms +x ${BITWIG_HOME}/bin/BitwigAudioEngine-X64-SSE41
	fperms +x ${BITWIG_HOME}/bin/BitwigAudioEngine-X64-AVX2
	fperms +x ${BITWIG_HOME}/bin/BitwigVampHost
	fperms +x ${BITWIG_HOME}/bin/lwjgl.jar
	fperms +x ${BITWIG_HOME}/bin/show-file-dialog-gtk3
	fperms +x ${BITWIG_HOME}/bin/show-splash-gtk
	fperms 755 ${BITWIG_HOME}/lib/jre/lib/* \
		${BITWIG_HOME}/lib/jre/lib/server/libjsig.so \
		${BITWIG_HOME}/lib/jre/lib/server/libjvm.so \
		${BITWIG_HOME}/lib/jre/bin/keytool \
		${BITWIG_HOME}/lib/jre/bin/jrunscript
	fperms 644 ${BITWIG_HOME}/lib/jre/lib/classlist \
		${BITWIG_HOME}/lib/jre/lib/jrt-fs.jar \
		${BITWIG_HOME}/lib/jre/lib/jvm.cfg \
		${BITWIG_HOME}/lib/jre/lib/modules \
		${BITWIG_HOME}/lib/jre/lib/psfontj2d.properties \
		${BITWIG_HOME}/lib/jre/lib/psfont.properties.ja \
		${BITWIG_HOME}/lib/jre/lib/tzdb.dat
	dosym ${BITWIG_HOME}/bitwig-studio /usr/bin/bitwig-studio

	if use abi_x86_32; then
		fperms +x ${BITWIG_HOME}/bin/BitwigPluginHost-X86-SSE41
	else
		rm -f "${ED}/${BITWIG_HOME}/bin/BitwigPluginHost-X86-SSE41"
	fi

	doicon -s scalable usr/share/icons/hicolor/scalable/apps/com.bitwig.BitwigStudio.svg
	sed -i \
	-e 's/Icon=.*/Icon=bitwig-studio/' \
	-e 's/Categories=.*/Categories=AudioVideo;Audio;AudioVideoEditing/' \
	-e '/Version=1.5/d' \
	usr/share/applications/com.bitwig.BitwigStudio.desktop || die 'sed on desktop file failed'
	domenu usr/share/applications/com.bitwig.BitwigStudio.desktop
	doicon -s scalable -c mimetypes usr/share/icons/hicolor/scalable/mimetypes/*.svg
	insinto /usr/share/mime/packages
	doins usr/share/mime/packages/com.bitwig.BitwigStudio.xml
}
