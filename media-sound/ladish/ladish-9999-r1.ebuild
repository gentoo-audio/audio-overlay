# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="6"

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE='threads(+)'

inherit git-r3 python-single-r1 waf-utils flag-o-matic

DESCRIPTION="LADI Session Handler - a session management system for JACK applications"
HOMEPAGE="http://ladish.org/ https://github.com/LADI/ladish"
EGIT_REPO_URI="https://github.com/nick87720z/ladish.git"
EGIT_HAS_SUBMODULES=

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="doc lash python"
REQUIRED_USE="${PYTHON_REQUIRED_USE}
	python? ( lash )"

# Gentoo bug #477734
RDEPEND="!media-libs/lash
	!media-sound/lash[-ladish]
	|| ( media-sound/jack-audio-connection-kit[dbus]
	     media-sound/jack2[dbus] )
	>=x11-libs/flowcanvas-0.6.4
	>=dev-libs/glib-2.20.3
	>=x11-libs/gtk+-2.20.0:2
	>=dev-libs/dbus-glib-0.74
	>=dev-libs/expat-2.0.1
	${PYTHON_DEPS}"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	virtual/pkgconfig"

DOCS=( AUTHORS NEWS README )

src_prepare() {
	default
	append-cxxflags "-std=c++11"
}

src_configure() {
#	append-cxxflags "-std=c++11"
	waf-utils_src_configure \
		$(usex doc --doxygen "") \
		$(usex lash --enable-liblash "") \
		$(usex python --enable-pylash "")
}

src_install() {
	use doc && HTML_DOCS=( "${S}/build/default/html/" )
	waf-utils_src_install
	python_fix_shebang "${ED}"
}
