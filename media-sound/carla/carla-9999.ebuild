# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# requires proaudio overlay

EAPI=6
PYTHON_COMPAT=( python3_{4,5,6} )

inherit git-r3 python-r1

DESCRIPTION="Fully-featured audio plugin host, with support for many audio drivers and plugin formats."
HOMEPAGE="http://kxstudio.linuxaudio.org/"
EGIT_BRANCH="master"
EGIT_REPO_URI="https://github.com/falkTX/Carla.git"

LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~amd64"

IUSE_PLUGIN_UI="+plugin_ui_X +plugin_ui_gtk2 +plugin_ui_gtk3 +plugin_ui_qt4 +plugin_ui_qt5"


# FIXME: all these features are automagic, without build system options to enable/disable them

IUSE="qt5 bridges ${IUSE_PLUGIN_UI} +osc +jack alsa pulseaudio +sf2 +gig +sfz +plugins +fftw +ntk +opengl projectm +rdf"

DEPEND="${PYTHON_DEPS}
   qt5? ( dev-python/PyQt5[${PYTHON_USEDEP}] )
   !qt5? ( dev-python/PyQt4[${PYTHON_USEDEP}] )
   bridges? ( sys-libs/libmagic )
   osc? ( media-libs/liblo )
   alsa? ( media-libs/alsa-lib )
   jack? ( virtual/jack )
   pulseaudio? ( media-sound/pulseaudio )
   plugin_ui_X? ( x11-base/xorg-server )
   plugin_ui_gtk2? ( x11-libs/gtk+:2 )
   plugin_ui_gtk3? ( x11-libs/gtk+:3 )
   plugin_ui_qt4? ( dev-qt/qtgui:4 )
   plugin_ui_qt5? ( dev-qt/qtgui:5 )
   sf2? ( media-sound/fluidsynth )
   gig? ( media-sound/linuxsampler )
   sfz? ( media-sound/linuxsampler )
   plugins? ( dev-libs/mini-xml sys-libs/zlib )
   fftw? ( sci-libs/fftw:3.0 )
   ntk? ( x11-libs/ntk )
   opengl? ( virtual/opengl )
   projectm? ( media-libs/libprojectm )
   rdf? ( dev-python/rdflib[${PYTHON_USEDEP}] )"

#DEPEND="${PYTHON_DEPS}
#   qt5? ( dev-python/PyQt5[${PYTHON_USEDEP}] )
#   !qt5? ( dev-python/PyQt4[${PYTHON_USEDEP}] )
#   media-libs/liblo
#   media-libs/alsa-lib
#   virtual/jack
#   media-sound/pulseaudio
#   sys-libs/libmagic
#   x11-base/xorg-server
#   x11-libs/gtk+:2
#   x11-libs/gtk+:3
#   dev-qt/qtgui:4
#   dev-qt/qtgui:5
#   media-sound/fluidsynth
#   media-sound/linuxsampler
#   dev-libs/mini-xml
#   sys-libs/zlib
#   sci-libs/fftw:3.0
#   x11-libs/ntk
#   virtual/opengl
#   media-libs/libprojectm
#   dev-python/rdflib[${PYTHON_USEDEP}]"

RDEPEND=${DEPEND}

src_compile() {
   DEFAULT_QT=$(usex qt5 5 4) emake
}

src_install() {
   emake DESTDIR="${D}" PREFIX="/usr" install
}

pkg_pretend() {
	elog "All use flags, appart of qt5/qt4 switch, only pull in dependencies."
	elog "For now carla enables support for all of them, if detects installed."
}

