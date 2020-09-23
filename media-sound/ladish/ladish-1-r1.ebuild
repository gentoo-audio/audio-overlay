# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE='threads(+)'

inherit flag-o-matic python-single-r1 waf-utils

DESCRIPTION="LADI Session Handler - a session management system for JACK applications"
HOMEPAGE="https://github.com/LADI/ladish"
if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/LADI/${PN}.git"
	KEYWORDS=""
	EGIT_SUBMODULES=()
else
	inherit vcs-snapshot
	SRC_URI="https://github.com/LADI/ladish/archive/${P}.tar.gz"
	KEYWORDS="~amd64"
fi
LICENSE="GPL-2"
SLOT="0"
RESTRICT="mirror"

IUSE="debug doc lash python"
REQUIRED_USE="${PYTHON_REQUIRED_USE}
	python? ( lash ) "

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
	"${FILESDIR}/${PN}-configure-gladish.patch"
	"${FILESDIR}/${P}-configure-libdir.patch"
	"${FILESDIR}/${P}-add-includes-for-getrlimit.patch"
	"${FILESDIR}/${P}-gui-resources-only-when-enabled.patch"
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
		$(usex python '--enable-pylash' '')
	)
	waf-utils_src_configure "${mywafconfargs[@]}"
}

src_install() {
	use doc && HTML_DOCS="${S}/build/default/html/*"
	waf-utils_src_install
	python_fix_shebang "${ED}"
}
