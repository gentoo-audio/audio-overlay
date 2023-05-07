# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )
PYTHON_REQ_USE='threads(+)'

inherit python-any-r1 waf-utils

DESCRIPTION="Library for easy interaction with monome devices"
HOMEPAGE="https://github.com/monome/libmonome"
if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/monome/libmonome.git"
else
	SRC_URI="https://github.com/monome/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi
LICENSE="ISC"
SLOT="0"
RESTRICT="mirror"

IUSE="osc python udev"

RDEPEND="udev? ( virtual/libudev )
	osc? ( media-libs/liblo )
	python? ( dev-python/cython )"
DEPEND="${RDEPEND}"
BDEPEND="${PYTHON_DEPS}"

src_configure() {
	local mywafconfargs=(
		$(usex osc "" --disable-osc)
		$(usex python --enable-python "")
		$(usex udev "" --disable-udev)
	)
	waf-utils_src_configure ${mywafconfargs[@]}
}
