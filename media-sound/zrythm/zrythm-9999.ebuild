# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson git-r3 gnome2-utils xdg

DESCRIPTION="Digital audio workstation designed to be featureful and easy to use"
HOMEPAGE="https://www.zrythm.org/"
EGIT_REPO_URI="https://gitlab.com/zrythm/zrythm"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="doc mp3"

DEPEND="
	mp3? ( media-video/ffmpeg[mp3] )
	>=media-libs/lilv-0.24.6
	>=media-libs/suil-0.10.4[qt5]
	dev-libs/libyaml
	media-fonts/cantarell
	media-libs/libsndfile
	media-libs/lv2
	sci-libs/fftw:3.0
	x11-libs/gtk+:3
"
RDEPEND="${DEPEND}"
BDEPEND=""

src_unpack() {
	git-r3_src_unpack
	cd "${S}"/subprojects
	git clone https://git.zrythm.org/git/libaudec
	git clone https://git.zrythm.org/git/zrythm-cyaml libcyaml
}

src_prepare() {
	sed -i -e "/docdir/s/${PN}/${P}/" \
		-e "s/lv2_dep,/dependency('fftw3_threads'),\ndependency('fftw3f_threads'),\n&/" \
		meson.build || die
	default
}

src_configure() {
	local emesonargs=(
		-Denable_ffmpeg=$(usex mp3 true false)
		-Dgen_dev_docs=false
		-Dmanpage=true
		-Duser_manual=$(usex doc true false)
	)
	meson_src_configure
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
