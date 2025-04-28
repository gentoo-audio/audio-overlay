# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Reboot of seq24, a minimal loop based midi sequencer"
HOMEPAGE="https://github.com/ahlstromcj/sequencer64"
if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/ahlstromcj/sequencer64.git"
	KEYWORDS=""
else
	SRC_URI="https://github.com/ahlstromcj/sequencer64/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi
LICENSE="GPL-2"
SLOT="0"
RESTRICT="mirror"

IUSE="cli jack lash qt5"

RDEPEND="
	>=dev-libs/libsigc++-2.2:2
	media-libs/libpng:=
	media-libs/alsa-lib
	jack? ( virtual/jack )
	lash? ( || ( media-sound/lash media-sound/ladish[lash] ) )
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
	)
	!qt5? ( dev-cpp/gtkmm:2.4 )"
DEPEND="${RDEPEND}"

src_prepare()
{
	default
	./bootstrap
}

src_configure()
{
	local -a myeconfargs=(
		--disable-portmidi
		--enable-rtmidi
		$(use_enable cli)
		$(use_enable jack)
		$(use_enable jack jack-session)
		$(use_enable lash)
		$(use_enable qt5 qt)
	)
	econf "${myeconfargs[@]}"
}

src_install()
{
	emake DESTDIR="${D}" install

	newicon resources/pixmaps/seq64.xpm sequencer64.xpm
	make_desktop_entry seq64 sequencer64 sequencer64
}
