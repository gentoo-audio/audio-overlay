# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

# Required by waf
PYTHON_COMPAT=( python2_7 python3_4 python3_5 python3_6 )
PYTHON_REQ_USE='threads(+)'

inherit python-any-r1 waf-utils

DESCRIPTION="A set of plugins to deteriorate the sound quality"
HOMEPAGE="https://github.com/blablack/deteriorate-lv2"
if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/blablack/deteriorate-lv2.git"
	KEYWORDS=""
else
	SRC_URI="https://github.com/blablack/deteriorate-lv2/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi
LICENSE="GPL-3"
SLOT="0"
DOCS=""

RDEPEND="dev-cpp/gtkmm:2.4
	x11-libs/gtk+:2
	x11-libs/cairo
	media-libs/lv2
	media-libs/lvtk[gtk2]"

DEPEND="${RDEPEND}"
