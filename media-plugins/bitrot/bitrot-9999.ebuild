# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

# Required by waf
PYTHON_COMPAT=( python3_6 python3_7 python3_8 )
PYTHON_REQ_USE='threads(+)'

inherit git-r3 python-any-r1 waf-utils

DESCRIPTION="A set of LV2 and LADSPA plugins for glitch effects"
HOMEPAGE="https://github.com/grejppi/bitrot"
EGIT_REPO_URI="https://github.com/grejppi/bitrot.git"
KEYWORDS=""
LICENSE="Apache-2.0"
SLOT="0"

DEPEND="${PYTHON_DEPS}"

src_prepare() {
	# Fix hardcoded libdir
	sed -i -e "s|\${{PREFIX}}/lib/|\${{PREFIX}}/$(get_libdir)/|" plugins/wscript || die "sed failed"

	default
}
