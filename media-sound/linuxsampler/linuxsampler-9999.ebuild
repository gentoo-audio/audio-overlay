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
IUSE="alsa dbus doc dssi flac jack ladspa lv2 sf2 sqlite static-libs vorbis"
REQUIRED_USE="|| ( alsa jack )"

# media-libs/dssi, media-libs/flac, media-libs/ladspa, media-libs/lv2, media-libs/libogg,
# media-libs/libvorbis, sys-apps/dbus automagic
# sys-apps/dbus is linked to the libraries but not declared anywhere in the sources
RDEPEND=">media-libs/libgig-4
	media-libs/libsndfile
	alsa? ( media-libs/alsa-lib )
	dbus? ( sys-apps/dbus )
	dssi? ( media-libs/dssi )
	flac? ( media-libs/flac )
	jack? ( virtual/jack )
	ladspa? ( media-libs/ladspa-sdk )
	lv2? ( media-libs/lv2 )
	sqlite? ( >=dev-db/sqlite-3.3 )
	vorbis? (
		media-libs/libogg
		media-libs/libvorbis
	)"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen )"

DOCS=( AUTHORS ChangeLog NEWS README )

src_configure() {
	emake -f Makefile.svn

	# upstream does not support --disable-static during configuration,
	# just --enable-static=no
	econf \
		$(use_enable alsa alsa-driver) \
		--disable-arts-driver \
		$(use_enable jack jack-driver) \
		$(use_enable sqlite instruments-db) \
		$(use_enable sf2 sf2-engine) \
		$(! has static-libs && echo --enable-static=no)
}

src_compile() {
	emake
	use doc && emake docs
}

src_install() {
	emake DESTDIR="${D}" install

	# for some reason static libs are installed even when disabled in configuration
	# so we have to remove them manually
	! use static-libs && find "${D}" -name "*.la" -delete
}
