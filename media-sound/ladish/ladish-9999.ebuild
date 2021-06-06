# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8,9} )
PYTHON_REQ_USE='threads(+)'

inherit flag-o-matic python-single-r1 waf-utils

DESCRIPTION="LADI Session Handler - a session management system for JACK applications"
HOMEPAGE="https://ladish.org"
if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://git.nedk.org/lad/ladish.git"
	KEYWORDS=""
	EGIT_SUBMODULES=()
else
	inherit vcs-snapshot
	SRC_URI="https://github.com/LADI/ladish/archive/${P}.tar.gz
		https://git.nedk.org/lad/ladish.git/plain/waf -> ${P}-waf-2.0.22"
	KEYWORDS="~amd64"
fi
LICENSE="GPL-2"
SLOT="0"
RESTRICT="mirror"

IUSE="debug doc lash"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="media-libs/alsa-lib
	media-sound/jack2[dbus]
	sys-apps/dbus
	dev-libs/expat
	lash? ( !media-sound/lash )
	${PYTHON_DEPS}"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	virtual/pkgconfig"

DOCS=( AUTHORS README NEWS )

PATCHES=(
	"${FILESDIR}/${P}-disable-gladish.patch"
)

src_prepare()
{
	sed -i -e "s/RELEASE = False/RELEASE = True/" wscript
	append-cxxflags '-std=c++11'
	default
}

src_configure() {
	local -a mywafconfargs=(
		--distnodeps
		$(usex debug --debug '')
		$(usex doc --doxygen '')
		$(usex lash '--enable-liblash' '')
	)
	waf-utils_src_configure "${mywafconfargs[@]}"
}

src_install() {
	use doc && HTML_DOCS="${S}/build/default/html/*"
	waf-utils_src_install
	python_fix_shebang "${ED}"
}
