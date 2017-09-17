# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} )
PYTHON_REQ_USE='threads(+),xml(+)'

inherit git-r3 python-single-r1 waf-utils multilib

DESCRIPTION="A simple but extensible successor of LADSPA"
HOMEPAGE="http://lv2plug.in/"
EGIT_REPO_URI="https://github.com/drobilla/lv2.git"

LICENSE="ISC"
SLOT="0"
KEYWORDS=""
IUSE="coverage debug doc plugins test"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="
	${PYTHON_DEPS}
	plugins? ( x11-libs/gtk+:2 media-libs/libsndfile )"
RDEPEND="${DEPEND}
	dev-python/lxml[${PYTHON_USEDEP}]
	dev-python/pygments[${PYTHON_USEDEP}]
	dev-python/rdflib[${PYTHON_USEDEP}]
	!<media-libs/slv2-0.4.2
	!media-libs/lv2core
	!media-libs/lv2-ui"
DEPEND="${DEPEND}
	plugins? ( virtual/pkgconfig )
	doc? ( app-doc/doxygen dev-python/rdflib app-text/asciidoc )"
DOCS=( "README.md" )

src_configure() {
	waf-utils_src_configure \
		--docdir="${EPREFIX}"/usr/share/doc/${PF} \
		--lv2dir="${EPREFIX}"/usr/$(get_libdir)/lv2 \
		--copy-headers \
		$(usex plugins '' --no-plugins) \
		$(usex doc     '--docs --online-docs' '') \
		$(use test     '--test --verbose-tests' '') \
		$(use debug    --debug '') \
		$(use coverage '' --no-coverage)
}

src_install() {
	waf-utils_src_install
	python_fix_shebang "${D}"
}

src_test() {
	./waf test || die
}
