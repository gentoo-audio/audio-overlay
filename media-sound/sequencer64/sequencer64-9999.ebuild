# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils

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

IUSE="jack lash"

RDEPEND="dev-cpp/gtkmm:2.4
	>=dev-libs/libsigc++-2.2:2
	media-libs/libpng:=
	media-libs/alsa-lib
	jack? ( virtual/jack )
	lash? ( || ( media-sound/lash media-sound/ladish[lash] ) )"

DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-fix-configure-ac-error.patch"
	"${FILESDIR}/${PN}-fix-configureac-use-rtmidi-as-default-backend.patch"
)

src_prepare()
{
	default
	./bootstrap
}

src_configure()
{
	local -a myeconfargs=(
		$(use_enable jack)
		$(use_enable jack jack-session)
		$(use_enable lash)
	)
	econf "${myeconfargs[@]}"
}

src_install()
{
	emake DESTDIR="${D}" install

	newicon resources/pixmaps/seq64.xpm sequencer64.xpm
	make_desktop_entry seq64 sequencer64 sequencer64
}
