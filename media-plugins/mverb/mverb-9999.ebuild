# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3 desktop

DESCRIPTION="Studio quality, open-source reverb"
HOMEPAGE="https://distrho.sourceforge.io/ports.php"
EGIT_REPO_URI="https://github.com/DISTRHO/MVerb.git"
KEYWORDS=""
LICENSE="GPL-3"
SLOT="0"

IUSE="dssi ladspa +lv2 standalone vst"

REQUIRED_USE="|| ( dssi ladspa lv2 vst standalone )"

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
		BUILD_LADSPA=$(usex ladspa true false)
		BUILD_LV2=$(usex lv2 true false)
		BUILD_VST=$(usex vst true false)
	)

	emake "${myemakeargs[@]}"
}

src_install() {
	if use standalone; then
		dobin bin/MVerb
		make_desktop_entry MVerb MVerb ${PN} "AudioVideo;AudioVideoEditing"
	fi
	if use dssi; then
		insopts -m0755
		insinto /usr/$(get_libdir)/dssi
		doins bin/MVerb-dssi.so
		doins -r bin/MVerb-dssi
	fi
	if use ladspa; then
		insopts -m0755
		insinto /usr/$(get_libdir)/ladspa
		doins bin/MVerb-ladspa.so
	fi
	if use lv2; then
		insopts -m0755
		insinto /usr/$(get_libdir)/lv2
		doins -r bin/MVerb.lv2
	fi
	if use vst; then
		insopts -m0755
		insinto /usr/$(get_libdir)/vst
		doins bin/MVerb-vst.so
	fi
}
