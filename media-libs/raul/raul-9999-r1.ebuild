# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} )
PYTHON_REQ_USE='threads(+)'

inherit git-r3 python-any-r1 waf-utils

DESCRIPTION="C++ utility library primarily aimed at audio/musical applications"
HOMEPAGE="https://drobilla.net/software/raul"
EGIT_REPO_URI="https://git.drobilla.net/raul.git/"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS=""
IUSE="coverage debug doc test"

RDEPEND=""
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	virtual/pkgconfig
	doc? ( app-doc/doxygen )"

DOCS=( AUTHORS NEWS README )

src_configure() {
	waf-utils_src_configure \
		$(usex test     --test '') \
		$(usex coverage '' --no-coverage) \
		$(usex debug    --debug '') \
		$(usex doc     --docs '')
}

src_test() {
	./waf test || die
}
