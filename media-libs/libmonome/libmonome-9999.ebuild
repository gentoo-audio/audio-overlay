# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_4 python3_5 python3_6 )
PYTHON_REQ_USE='threads(+)'

inherit git-r3 python-any-r1 waf-utils

DESCRIPTION="Library for easy interaction with monome devices"
HOMEPAGE="https://github.com/monome/libmonome"
EGIT_REPO_URI="https://github.com/monome/libmonome.git"
KEYWORDS=""
LICENSE="ISC"
SLOT="0"

IUSE="osc -python udev"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="udev? ( virtual/libudev )
	osc? ( media-libs/liblo )
	python? ( dev-python/cython )"
DEPEND="${RDEPEND}"

src_configure() {
	local mywafconfargs=(
		$(usex osc "" --disable-osc)
		$(usex python --enable-python "")
		$(usex udev "" --disable-udev)
	)
	waf-utils_src_configure ${mywafconfargs[@]}
}
