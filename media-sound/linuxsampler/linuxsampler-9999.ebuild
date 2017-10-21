# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils subversion

DESCRIPTION="LinuxSampler is a software audio sampler engine with professional grade features"
HOMEPAGE="http://www.linuxsampler.org/"
ESVN_REPO_URI="https://svn.linuxsampler.org/svn/linuxsampler/trunk"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
# it also supports vst but it's masked in the tree at this moment
IUSE="alsa doc dssi jack ladspa lv2 sf2 sqlite static-libs"
REQUIRED_USE="|| ( alsa jack )"

# media-libs/dssi, media-libs/ladspa, media-libs/lv2 automagic
RDEPEND=">media-libs/libgig-4
	alsa? ( media-libs/alsa-lib )
	dssi? ( media-libs/dssi )
	jack? ( virtual/jack )
	ladspa? ( media-libs/ladspa-sdk )
	lv2? ( media-libs/lv2 )
	sqlite? ( >=dev-db/sqlite-3.3 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen )"

DOCS=( AUTHORS ChangeLog NEWS README )

src_configure() {
	emake -f Makefile.svn

	econf \
		$(use_enable alsa alsa-driver) \
		--disable-arts-driver \
		$(use_enable jack jack-driver) \
		$(use_enable sqlite instruments-db) \
		$(use_enable sf2 sf2-engine) \
		$(use_enable static-libs static)
}

src_compile() {
	emake
	use doc && emake docs
}
