# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_4 )
PYTHON_REQ_USE='threads(+)'

inherit python-any-r1 waf-utils

DESCRIPTION="FLTK fork, improved rendering via Cairo, streamlined and enhanced widget set"
HOMEPAGE="http://non.tuxfamily.org/wiki/NTK"
if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://git.tuxfamily.org/non/fltk.git/"
	KEYWORDS=""
else
	SRC_URI="https://github.com/original-male/ntk/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi
LICENSE="FLTK"
SLOT="0"

IUSE="-opengl"
REQUIRED_USE=""

RDEPEND="x11-libs/libX11
	media-libs/fontconfig
	x11-libs/libXft
	x11-libs/cairo[X]
	virtual/jpeg:*
	media-libs/libpng:*
	opengl? ( media-libs/glu )"
DEPEND="${PYTHON_DEPS}
	${RDEPEND}"

PATCHES=( "${FILESDIR}/${PN}-dont-run-ldconfig.patch"
	"${FILESDIR}/${PN}-no-default-cflags-optimizations.patch" )

src_configure() {
	local mywafconfargs=(
		$(usex opengl --enable-gl "")
	)
	waf-utils_src_configure ${mywafconfargs[@]}
}
