# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} )
PYTHON_REQ_USE='threads(+)'

inherit git-r3 waf-utils python-single-r1

DESCRIPTION="Library to make the use of LV2 plugins as simple as possible for applications"
HOMEPAGE="https://drobilla.net/software/lilv/"
EGIT_REPO_URI="https://git.drobilla.net/lilv.git"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+bash-completion coverage debug doc +dyn-manifest python static static-libs test +utils"

RDEPEND=">=media-libs/lv2-9999
	>=dev-libs/serd-9999
	>=dev-libs/sord-9999
	>=media-libs/sratom-9999
	media-libs/libsndfile"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
	test? ( dev-util/lcov )"

DOCS=( AUTHORS NEWS README )

src_configure() {
	waf-utils_src_configure \
	--docdir="${EPREFIX}"/usr/share/doc/${PF} \
	$(usex debug --debug '') \
	$(usex doc --docs '') \
	$(usex python --bindings '') \
	$(usex dyn-manifest --dyn-manifest '') \
	$(usex bash-completion '' --no-bash-completion) \
	$(usex static '--static-progs' '') \
	$(usex static-libs --static '') \
	$(usex test   '--test --verbose-tests' '') \
	$(usex utils '' --no-utils) \
	$(usex coverage '' --no-coverage) \
	--python="${PYTHON}" \
	--pythondir="${PYTHON_SITEDIR}"
}

src_test() {
    ./waf test || die
}

