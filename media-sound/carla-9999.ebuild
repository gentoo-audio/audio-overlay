# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# requires proaudio overlay
EAPI=5
inherit git-r3

DESCRIPTION="Fully-featured audio plugin host, with support for many audio drivers and plugin formats."
HOMEPAGE="http://kxstudio.linuxaudio.org/"
SRC_URI=""
EGIT_BRANCH="master"
EGIT_REPO_URI="https://github.com/falkTX/Carla.git"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+magic +osc jack alsa pulseaudio X +lv2ui -samplers -plugins +rdf"
DEPEND="|| ( dev-python/PyQt4 dev-python/PyQt5 )
   magic? ( sys-libs/libmagic )
   osc? ( media-libs/liblo )
   jack? ( media-sound/jack-audio-connection-kit )
   alsa? ( media-libs/alsa-lib )
   pulseaudio? ( media-sound/pulseaudio )
   X? ( x11-base/xorg-server )
   lv2ui? ( x11-libs/gtk+:2 x11-libs/gtk+:3 dev-python/PyQt4 dev-python/PyQt5 )
   samplers? ( media-sound/fluidsynth media-sound/linuxsampler )
   plugins? ( sci-libs/fftw:3.0 dev-libs/mini-xml sys-libs/zlib x11-libs/ntk virtual/opengl media-libs/libprojectm-qt )
   rdf? ( dev-python/rdflib )"
RDEPEND=${DEPEND}
src_compile() {
   emake

}
src_install() {
   emake DESTDIR="${D}" install
} 
