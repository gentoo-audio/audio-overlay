# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{4,5,6,7} )
inherit python-single-r1 xdg-utils

DESCRIPTION="Fully-featured audio plugin host, supports many audio drivers and plugin formats"
HOMEPAGE="http://kxstudio.linuxaudio.org/Applications:Carla"
if [[ ${PV} == *9999 ]]; then
	# Disable submodules to prevent external plugins from being built and installed
	inherit git-r3
	EGIT_REPO_URI="https://github.com/falkTX/Carla.git"
	EGIT_SUBMODULES=()
	KEYWORDS=""
else
	SRC_URI="https://github.com/falkTX/Carla/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	RESTRICT="mirror"
	KEYWORDS="~amd64"
	S="${WORKDIR}/Carla-${PV}"
fi
LICENSE="GPL-2 LGPL-3"
SLOT="0"

IUSE="-32bit alsa gtk gtk2 libav opengl osc -pulseaudio rdf sf2 sndfile -win64 -win32 X"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	$(python_gen_cond_dep 'dev-python/PyQt5[gui,opengl?,svg,widgets,${PYTHON_MULTI_USEDEP}]')
	virtual/jack
	32bit? ( sys-devel/gcc[multilib] )
	alsa? ( media-libs/alsa-lib )
	gtk? ( x11-libs/gtk+:3 )
	gtk2? ( x11-libs/gtk+:2 )
	osc? (
		media-libs/liblo
		media-libs/pyliblo
	)
	pulseaudio? ( media-sound/pulseaudio )
	rdf? ( dev-python/rdflib )
	sf2? ( media-sound/fluidsynth )
	sndfile? ( media-libs/libsndfile )
	win64? (
		virtual/wine
		cross-x86_64-w64-mingw32/binutils
		cross-x86_64-w64-mingw32/gcc
		cross-x86_64-w64-mingw32/mingw64-runtime[libraries,idl,tools]
	)
	win32? (
		virtual/wine[abi_x86_32]
		cross-i686-w64-mingw32/binutils
		cross-i686-w64-mingw32/gcc
		cross-i686-w64-mingw32/mingw64-runtime[libraries,idl,tools]
	)
	X? ( x11-base/xorg-server )"
DEPEND=${RDEPEND}

src_prepare() {
	sed -i -e "s|exec \$PYTHON|exec ${PYTHON}|" \
		data/carla \
		data/carla-control \
		data/carla-database \
		data/carla-jack-multi \
		data/carla-jack-single \
		data/carla-patchbay \
		data/carla-rack \
		data/carla-settings || die "sed failed"
	default
}

src_compile() {
	myemakeargs=(
		SKIP_STRIPPING=true
		HAVE_FFMPEG=false
		HAVE_ZYN_DEPS=false
		HAVE_ZYN_UI_DEPS=false
		HAVE_QT4=false
		HAVE_QT5=true
		HAVE_PYQT5=true
		DEFAULT_QT=5
		HAVE_ALSA=$(usex alsa true false)
		HAVE_FLUIDSYNTH=$(usex sf2 true false)
		HAVE_GTK2=$(usex gtk2 true false)
		HAVE_GTK3=$(usex gtk true false)
		HAVE_LIBLO=$(usex osc true false)
		HAVE_PULSEAUDIO=$(usex pulseaudio true false)
		HAVE_SNDFILE=$(usex sndfile true false)
		HAVE_X11=$(usex X true false)
		LIBDIR=${EPREFIX}/usr/$(get_libdir)
	)

	# Print which options are enabled/disabled
	make features PREFIX="${EPREFIX}/usr" "${myemakeargs[@]}"

	emake PREFIX="${EPREFIX}/usr" "${myemakeargs[@]}"

	if use 32bit; then
		emake PREFIX="${EPREFIX}/usr" LIBDIR=${EPREFIX}/usr/lib posix32
	fi

	if use win64; then
		emake PREFIX="${EPREFIX}/usr" win64 CC=x86_64-w64-mingw32-gcc CXX=x86_64-w64-mingw32-g++ AR=x86_64-w64-mingw32-ar RANLIB=x86_64-w64-mingw32-ranlib
		emake PREFIX="${EPREFIX}/usr" wine64
	fi

	if use win32; then
		emake PREFIX="${EPREFIX}/usr" win32 CC=i686-w64-mingw32-gcc CXX=i686-w64-mingw32-g++ RANLIB=i686-w64-mingw32-ranlib AR=i686-w64-mingw32-ar
		emake PREFIX="${EPREFIX}/usr" wine32
	fi
}

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}/usr" "${myemakeargs[@]}" install
	if ! use osc; then
		find "${ED}/usr" -iname "carla-control*" | xargs rm
	fi
}

pkg_postinst() {
	xdg_mimeinfo_database_update
	xdg_desktop_database_update
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_mimeinfo_database_update
	xdg_desktop_database_update
	xdg_icon_cache_update
}
