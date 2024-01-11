# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop unpacker xdg

DESCRIPTION="Multi-platform music-creation system for production, performance and DJing"
HOMEPAGE="http://bitwig.com"
SRC_URI="https://downloads.bitwig.com/stable/${PV}/${P}.deb"
LICENSE="Bitwig"
SLOT="0"
KEYWORDS="-* ~amd64"
RESTRICT="mirror"

IUSE="abi_x86_32 +jack cpu_flags_x86_sse4_1"
REQUIRED_USE="cpu_flags_x86_sse4_1"

DEPEND=""
RDEPEND="${DEPEND}
	app-arch/bzip2
	dev-libs/expat
	gnome-extra/zenity
	|| ( media-sound/jack2 media-video/pipewire[jack-sdk] )
	media-libs/alsa-lib
	media-libs/fontconfig
	media-libs/freetype
	media-libs/libpng:0/16
	media-libs/mesa
	sys-libs/zlib
	media-video/ffmpeg[libsoxr]
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

QA_PREBUILT="
	opt/bitwig-studio/.*
"

S=${WORKDIR}

src_prepare() {
	eapply_user

	sed -i \
	-e 's/Icon=.*/Icon=bitwig-studio/' \
	-e 's/Categories=.*/Categories=AudioVideo;Audio;AudioVideoEditing/' \
	-e '/Version=1.5/d' \
	usr/share/applications/com.bitwig.BitwigStudio.desktop || die 'sed on desktop file failed'
}

src_install() {
	dodir /opt
	cp -a opt/bitwig-studio "${ED}"/opt || die "cp failed"

	dosym ../../opt/bitwig-studio/bitwig-studio /usr/bin/bitwig-studio

	if ! use abi_x86_32; then
		rm "${ED}/opt/bitwig-studio/bin/BitwigPluginHost-X86-SSE41" || die
	fi

	doicon -s scalable usr/share/icons/hicolor/scalable/apps/com.bitwig.BitwigStudio.svg
	domenu usr/share/applications/com.bitwig.BitwigStudio.desktop
	doicon -s scalable -c mimetypes usr/share/icons/hicolor/scalable/mimetypes/*.svg
	insinto /usr/share/mime/packages
	doins usr/share/mime/packages/com.bitwig.BitwigStudio.xml
}

