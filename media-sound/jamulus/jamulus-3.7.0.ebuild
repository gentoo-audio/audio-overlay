# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop qmake-utils

MY_PV="${PV//\./_}"

DESCRIPTION="Internet jam session software"
HOMEPAGE="https://jamulus.io"
SRC_URI="https://github.com/jamulussoftware/${PN}/archive/r${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="headless"

DEPEND="
	dev-qt/qtcore:5=
	dev-qt/qtnetwork:5=
	dev-qt/qtconcurrent:5=
	dev-qt/qtxml:5=
	!headless? (
		dev-qt/qtdeclarative:5=
		dev-qt/qtgui:5=
		dev-qt/qtwidgets:5=
		virtual/jack
	)
"
RDEPEND="${DEPEND}"
BDEPEND=""

S="${WORKDIR}/${PN}-r${MY_PV}"

src_configure() {
	if use headless; then
		eqmake5 "CONFIG+=nosound headless" Jamulus.pro
	else
		eqmake5 Jamulus.pro
	fi
}

src_install() {
	dobin Jamulus

	dodoc README.md
	dodoc ChangeLog

	if ! use headless; then
		domenu distributions/jamulus.desktop
		doicon distributions/jamulus.png
	fi

	newconfd "${FILESDIR}"/${PN}-confd ${PN}-server
	newinitd "${FILESDIR}"/${PN}-initd ${PN}-server

	insinto /lib/systemd/system
	doins distributions/jamulus-server.service
}
