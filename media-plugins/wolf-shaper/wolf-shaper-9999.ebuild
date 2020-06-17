# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3

DESCRIPTION="Waveshaper plugin with spline-based graph editor"
HOMEPAGE="https://github.com/pdesaulniers/wolf-shaper"
EGIT_REPO_URI="https://github.com/pdesaulniers/wolf-shaper"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="dssi jack lv2 vst"

DEPEND="
	dssi? ( media-libs/dssi
		media-libs/liblo )
	jack? ( virtual/jack )
	lv2? ( media-libs/lv2 )
	virtual/opengl
	x11-libs/libX11
"
RDEPEND="${DEPEND}"
BDEPEND=""

REQUIRED_USE="|| ( dssi lv2 vst )"

src_prepare() {
	default
	sed -i -e 's:/local::' -e "s/lib\>/$(get_libdir)/" Makefile
	sed -i "/BASE_OPTS  =/s/=.*/= ${CFLAGS}/" \
		plugins/wolf-shaper/Common/Utils/generate-dpf-project.sh \
		dpf/dgl/Makefile.mk Makefile.mk
	use dssi || sed -i -e '/bin\/\*-dssi/d' Makefile
	use lv2 || sed -i -e '/bin\/\*\.lv2/d' Makefile
	use vst || sed -i -e '/bin\/\*-vst/d' Makefile
}

src_compile() {
	emake BUILD_DSSI=$(usex dssi true  false) \
		BUILD_JACK=$(usex jack true false) \
		BUILD_LV2=$(usex lv2 true false) \
		BUILD_VST2=$(usex vst true false) \
		SKIP_STRIPPING=true
}
