# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE='threads(+)'

inherit eutils flag-o-matic waf-utils python-any-r1 git-r3

DESCRIPTION="A GTK+ widget for interactive graph-like environments"
HOMEPAGE="http://drobilla.net/software/ganv/"
EGIT_REPO_URI="https://git.drobilla.net/ganv.git"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS=""
IUSE="coverage doc +fdgl +graphviz introspection light-theme nls test"

RDEPEND="
	>=dev-cpp/gtkmm-2.10:2.4=
	x11-libs/gtk+:2=
	graphviz? ( media-gfx/graphviz[gtk] )
	introspection? (
		app-text/yelp-tools
		dev-libs/gobject-introspection:=[doctool] )
	!!media-sound/drobilla
"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	nls? ( virtual/libintl )
	doc? ( app-doc/doxygen )
"

DOCS=( AUTHORS NEWS README )

src_configure() {
	append-cxxflags -std=c++11
	waf-utils_src_configure \
		$(usex graphviz '' --no-graphviz) \
		$(usex fdgl '' --no-fdgl) \
		$(usex nls '' --no-nls) \
		$(usex introspection --gir '') \
		$(usex light-theme --light-theme '') \
		$(usex doc --docs '') \
		$(usex test '--test --verbose-tests' '') \
		$(usex coverage '' --no-coverage)
}

src_test() {
	./waf test || die
}
