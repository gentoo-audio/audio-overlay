# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} )
PYTHON_REQ_USE='threads(+)'

inherit git-r3 python-any-r1 waf-utils

DESCRIPTION="Library for RDF syntax which supports reading and writing Turtle and NTriples"
HOMEPAGE="https://drobilla.net/software/serd/"
EGIT_REPO_URI="https://git.drobilla.net/serd.git"

LICENSE="ISC"
SLOT="0"
KEYWORDS=""
IUSE="coverage debug doc sanity-check static static-libs test +utils"

RDEPEND=""
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	doc? ( app-doc/doxygen )"

DOCS=( AUTHORS NEWS README.md )

src_configure() {
    waf-utils_src_configure \
        --docdir=/usr/share/doc/${PF} \
        $(usex test  '--test --verbose-tests' '') \
        $(usex doc         --docs '') \
        $(usex static-libs --static '') \
		$(usex static   --static-progs '') \
		$(usex debug       --debug '') \
		$(usex utils ''    --no-utils) \
		$(usex sanity-check --stack-check '') \
		$(usex coverage  '' --no-coverage)
}

src_test() {
    ./waf test || die
}

