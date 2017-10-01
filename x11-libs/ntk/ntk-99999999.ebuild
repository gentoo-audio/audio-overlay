# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_4 )
PYTHON_REQ_USE='threads(+)'

inherit git-r3 python-any-r1 waf-utils

DESCRIPTION="FLTK fork, improved rendering via Cairo, streamlined and enhanced widget set"
HOMEPAGE="http://non.tuxfamily.org/wiki/NTK"
EGIT_REPO_URI="git://git.tuxfamily.org/gitroot/non/fltk.git"
KEYWORDS=""
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
