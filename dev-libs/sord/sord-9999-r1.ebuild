# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} )
PYTHON_REQ_USE='threads(+)'

inherit git-r3 python-any-r1 waf-utils

DESCRIPTION="lightweight C library for storing RDF data in memory"
HOMEPAGE="https://drobilla.net/software/sord"
EGIT_REPO_URI="https://git.drobilla.net/sord.git"

LICENSE="ISC"
SLOT="0"
KEYWORDS=""
IUSE="coverage debug doc static static-libs test +utils"

# libpcre is automagic dependency
RDEPEND=">=dev-libs/serd-9999
	dev-libs/libpcre
	!!media-sound/drobilla"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	virtual/pkgconfig
	doc? ( app-doc/doxygen )"

DOCS=( AUTHORS NEWS README )

src_configure() {
	conf_args=(
		--docdir=/usr/share/doc/${PF}
		$(usex test        '--test --verbose-tests' '')
		$(usex doc         '--docs'                 '')
		$(usex static-libs '--static'               '')
		$(usex static      '--static-progs'         '')
		$(usex coverage    ''          '--no-coverage')
		$(usex debug       '--debug --dump=all'     '')
		$(usex utils       '' '--no-utils')
	)
	waf-utils_src_configure ${conf_args[@]}
}

src_test() {
	./waf test || die
}
