# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3 desktop

DESCRIPTION="Simple single-oscillator synth based on the Roland TB-303"
HOMEPAGE="https://distrho.sourceforge.io/plugins.php"
EGIT_REPO_URI="https://github.com/DISTRHO/Nekobi.git"
KEYWORDS=""
LICENSE="GPL-2"
SLOT="0"

IUSE="dssi +lv2 standalone vst"

REQUIRED_USE="|| ( dssi lv2 vst standalone )"

RDEPEND="media-libs/mesa
	x11-libs/libX11
	standalone? ( virtual/jack )
	dssi? ( media-libs/liblo )"
DEPEND="${RDEPEND}"

PATCHES="${FILESDIR}/${PN}-allow-configuring-which-plugin-types-to-build.patch"

src_compile() {
	myemakeargs=(
		SKIP_STRIPPING=true
		HAVE_JACK=$(usex standalone true false)
		HAVE_LIBLO=$(usex dssi true false)
		BUILD_DSSI=$(usex dssi true false)
		BUILD_LV2=$(usex lv2 true false)
		BUILD_VST=$(usex vst true false)
	)

	emake "${myemakeargs[@]}"
}

src_install() {
	if use standalone; then
		dobin bin/Nekobi
		newicon plugins/Nekobi/artwork/tail.png ${PN}.png
		make_desktop_entry Nekobi Nekobi ${PN} "AudioVideo;AudioVideoEditing"
	fi
	if use dssi; then
		insopts -m0755
		insinto /usr/$(get_libdir)/dssi
		doins bin/Nekobi-dssi.so
		doins -r bin/Nekobi-dssi
	fi
	if use lv2; then
		insopts -m0755
		insinto /usr/$(get_libdir)/lv2
		doins -r bin/Nekobi.lv2
	fi
	if use vst; then
		insopts -m0755
		insinto /usr/$(get_libdir)/vst
		doins bin/Nekobi-vst.so
	fi
}
