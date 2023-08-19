# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )
PYTHON_REQ_USE="threads(+)"
inherit python-any-r1 waf-utils

DESCRIPTION="libdbus helper library"
HOMEPAGE="https://github.com/LADI/cdbus"
if [[ "${PV}" == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/LADI/cdbus.git"
	EGIT_BRANCH="main"
else
	CDBUS_COMMIT="32cb2e2519e4088421f2de1b2d46003d1cac6d6c"
	SRC_URI="https://github.com/LADI/cdbus/archive/${CDBUS_COMMIT}.tar.gz -> ${P}.gh.tar.gz"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${CDBUS_COMMIT}"
fi

LICENSE="GPL-2 || ( GPL-2 AFL-2.1 )"
SLOT="0"

DEPEND="
	sys-apps/dbus
"
RDEPEND="${DEPEND}"
BDEPEND="
	virtual/pkgconfig

	${PYTHON_DEPS}
"

src_prepare() {
	rm -rf ".git" || die "Failed to remove git dir"
	default
}

src_install() {
	waf-utils_src_install

	find "${ED}" \( -iname "gpl*.txt*" -o -iname "afl*.txt*" \) -delete || die
}
