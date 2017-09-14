# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} )
PYTHON_REQ_USE='threads(+)'

inherit git-r3 waf-utils flag-o-matic python-any-r1

DESCRIPTION="lightweight C library for loading and wrapping LV2 plugin UIs"
HOMEPAGE="https://drobilla.net/software/suil"
EGIT_REPO_URI="https://git.drobilla.net/suil.git"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug doc +gtk +qt4 +qt5 static-libs"

RDEPEND=">=media-libs/lv2-9999
	gtk? ( x11-libs/gtk+:2
	       x11-libs/gtk+:3 )
	qt4? ( dev-qt/qtgui:4 )
	qt5? ( dev-qt/qtwidgets:5 )
	x11-libs/libX11
	!!media-sound/drobilla"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	virtual/pkgconfig
	doc? ( app-doc/doxygen )"

DOCS=( AUTHORS NEWS README )

src_configure() {
	use qt5 && append-cxxflags -std=c++11

	waf-utils_src_configure \
	--mandir="${EPREFIX}/usr/share/man" \
	--docdir="${EPREFIX}/usr/share/doc/${PF}" \
	$(usex gtk '' --no-gtk) \
	$(usex qt4 '' --no-qt4) \
	$(usex qt5 '' --no-qt5) \
	$(usex debug --debug '') \
	$(usex doc   --docs '') \
	$(usex static-libs --static '')
}
