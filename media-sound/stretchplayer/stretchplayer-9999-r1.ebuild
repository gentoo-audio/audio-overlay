# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="6"

inherit flag-o-matic cmake-utils git-r3

DESCRIPTION="Audio player with time stretch and pitch shift"
HOMEPAGE="https://github.com/smbolton/stretchplayer http://www.teuton.org/~gabriel/stretchplayer/"
EGIT_REPO_URI="https://github.com/smbolton/stretchplayer.git"

LICENSE="GPL-2 GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="alsa debug jack"

RDEPEND="media-libs/rubberband
	>=dev-qt/qtcore-4.5:4
	>=dev-qt/qtgui-4.5:4
	media-libs/libsndfile
	jack? ( virtual/jack )
	alsa? ( media-libs/alsa-lib )"

DEPEND="${RDEPEND}
	dev-util/cmake"

DOCS=( AUTHORS BUGS.txt COPYING README.txt gpl-2.0.txt gpl-3.0.txt Documentation )
ICON_SIZES="16 22 24 32 48"

src_configure() {
	append-cxxflags -fpermissive
	cmake-utils_src_configure \
	-DCMAKE_BUILD_TYPE="$(usex debug Debug Release)" \
	-DAUDIO_SUPPORT_ALSA=$(usex alsa)
	-DAUDIO_SUPPORT_JACK=$(usex jack)
}

#src_compile() {
#	cmake-utils_src_compile
#}

src_install() {
	cmake-utils_src_install
	newicon -s scalable "art/stretchplayer-icon.svg" stretchplayer.svg
	for size in ${ICON_SIZES}; do
		echo "Installing icon for size ${size}"
		newicon -s ${size} "art/stretchplayer-icon-${size}x${size}.png" stretchplayer.png
	done
}

pkg_postinst() {
	echo
	elog "Make sure that you use a JACK buffer size larger than 256."
	elog "Less than 256 is known to have real-time issues."
}
