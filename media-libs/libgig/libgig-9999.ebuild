# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils multilib subversion

DESCRIPTION="C++ library for loading/modifying GigaStudio, SoundFont, KORG, AKAI, DLS files"
HOMEPAGE="http://www.linuxsampler.org/libgig/"
ESVN_REPO_URI="https://svn.linuxsampler.org/svn/libgig/trunk"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="doc static-libs"

RDEPEND=">=media-libs/libsndfile-1.0.2
	>=media-libs/audiofile-0.2.3"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen )"

DOCS=( AUTHORS ChangeLog NEWS README TODO )

src_configure() {
	emake -f Makefile.svn
	econf \
		$(use_enable static-libs static)
}

src_compile() {
	emake

	if use doc ; then
		emake docs
	fi
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS ChangeLog NEWS README TODO

	# For libgig.so to be found at runtime
	printf "LDPATH=\"${EPREFIX}/usr/$(get_libdir)/libgig/\"" > 99${PN}
	doenvd "99${PN}"

	if use doc ; then
		dohtml -r doc/html/*
	fi
}
