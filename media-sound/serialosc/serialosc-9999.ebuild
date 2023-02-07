# Copyright 1999-2023 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..9} )
PYTHON_REQ_USE='threads(+)'
NO_WAF_LIBDIR=yes

inherit git-r3 python-any-r1 waf-utils

DESCRIPTION="Multi-device, bonjour-capable monome OSC server"
HOMEPAGE="https://github.com/monome/serialosc"
EGIT_REPO_URI="https://github.com/monome/serialosc.git"
EGIT_SUBMODULES=( "*" "-third-party/libuv" )
if [[ ${PV} == *9999 ]]; then
	KEYWORDS=""
else
	EGIT_COMMIT="v${PV}"
	KEYWORDS="~amd64"
fi
LICENSE="ISC"
SLOT="0"

IUSE="zeroconf"

RDEPEND="virtual/libudev
	media-libs/liblo
	>=media-libs/libmonome-1.4.1
	dev-libs/libuv
	zeroconf? ( net-dns/avahi[mdnsresponder-compat] )"
DEPEND="${RDEPEND}"
BDEPEND="${PYTHON_DEPS}"

src_configure() {
	local mywafconfargs=(
		--enable-system-libuv
		$(usex zeroconf "" --disable-zeroconf)
	)
	waf-utils_src_configure ${mywafconfargs[@]}
}
