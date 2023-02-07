# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Required by waf
PYTHON_COMPAT=( python3_{6,7,8,9} )
PYTHON_REQ_USE='threads(+)'

inherit python-any-r1 waf-utils

DESCRIPTION="FLTK fork, improved rendering via Cairo, streamlined and enhanced widget set"
HOMEPAGE="https://non.tuxfamily.org/wiki/NTK"
if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/gentoo-audio/ntk.git"
	KEYWORDS=""
else
	SRC_URI="https://github.com/gentoo-audio/ntk/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi
LICENSE="FLTK"
SLOT="0"
RESTRICT="mirror"

IUSE="-opengl"

RDEPEND="x11-libs/libX11
	media-libs/fontconfig
	x11-libs/libXft
	x11-libs/cairo[X]
	virtual/jpeg:*
	media-libs/libpng:*
	opengl? ( media-libs/glu )"
DEPEND="${RDEPEND}"
BDEPEND="${PYTHON_DEPS}"

PATCHES=( "${FILESDIR}/${PN}-dont-run-ldconfig.patch"
	"${FILESDIR}/${PN}-no-default-cflags-optimizations.patch" )

src_configure() {
	local mywafconfargs=(
		$(usex opengl --enable-gl "")
	)
	waf-utils_src_configure ${mywafconfargs[@]}
}
