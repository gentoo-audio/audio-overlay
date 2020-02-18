# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3

DESCRIPTION=""
HOMEPAGE="https://github.com/pdesaulniers/wolf-spectrum"
EGIT_REPO_URI="https://github.com/pdesaulniers/wolf-spectrum"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="jack lv2 vst"

DEPEND="
	lv2? ( media-libs/lv2 )
	virtual/jack
	virtual/opengl
	x11-libs/libX11
"
RDEPEND="${DEPEND}"
BDEPEND=""

src_prepare() {
	default
	sed -i -e 's:/local::' -e "s/lib\>/$(get_libdir)/" Makefile
	sed -i "/BASE_OPTS  =/s/=.*/= ${CFLAGS}/" \
		plugins/wolf-spectrum/Common/Utils/generate-dpf-project.sh \
		dpf/dgl/Makefile.mk Makefile.mk
	sed -i -e '/bin\/\*-dssi/d' Makefile
	use lv2 || sed -i -e '/bin\/\*\.lv2/d' Makefile
	use vst || sed -i -e '/bin\/\*-vst/d' Makefile
}

src_compile() {
	emake BUILD_JACK=true SKIP_STRIPPING=true \
		BUILD_LV2=$(usex lv2 true false) \
		BUILD_VST2=$(usex vst true false)
}
