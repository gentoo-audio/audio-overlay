# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} )
PYTHON_REQ_USE='threads(+)'

inherit git-r3 python-any-r1 waf-utils

DESCRIPTION="Library for serialising LV2 atoms to/from RDF, particularly the Turtle syntax"
HOMEPAGE="https://drobilla.net/software/sratom/"
EGIT_REPO_URI="https://git.drobilla.net/sratom.git"

LICENSE="ISC"
SLOT="0"
KEYWORDS=""
IUSE="coverage debug doc static-libs test"

RDEPEND="!!media-sound/drobilla
	>=media-libs/lv2-9999
	>=dev-libs/serd-9999
	>=dev-libs/sord-9999"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
	coverage? ( dev-util/lcov )"

DOCS=( NEWS README )

src_configure() {
	waf-utils_src_configure \
		--docdir=/usr/share/doc/${PF} \
		$(usex debug       --debug '') \
		$(usex doc         --docs  '') \
		$(usex static-libs --static '') \
		$(usex coverage   '' --no-coverage) \
		$(usex test '--test --verbose-tests' '')
}

src_test() {
	./waf test || die
}

