# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_4 python3_5 python3_6 )
PYTHON_REQ_USE='threads(+)'
NO_WAF_LIBDIR=yes

inherit git-r3 python-any-r1 waf-utils

DESCRIPTION="Multi-device, bonjour-capable monome OSC server"
HOMEPAGE="https://github.com/monome/serialosc"
EGIT_REPO_URI="https://github.com/monome/serialosc.git"
EGIT_SUBMODULES=( "*" "-third-party/libuv" )
KEYWORDS=""
LICENSE="ISC"
SLOT="0"

IUSE="-zeroconf"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="virtual/libudev
	media-libs/liblo
	media-libs/libmonome
	dev-libs/libuv
	zeroconf? ( net-dns/avahi[mdnsresponder-compat] )"
DEPEND="${RDEPEND}"

src_configure() {
	local mywafconfargs=(
		--enable-system-libuv
		$(usex zeroconf "" --disable-zeroconf)
	)
	waf-utils_src_configure ${mywafconfargs[@]}
}
