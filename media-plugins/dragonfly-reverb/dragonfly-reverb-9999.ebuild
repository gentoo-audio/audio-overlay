# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A set of free reverb effects"
HOMEPAGE="https://github.com/michaelwillis/dragonfly-reverb"
if [[ ${PV} == *9999 ]]; then
	inherit git-r3 autotools
	EGIT_REPO_URI="https://github.com/michaelwillis/dragonfly-reverb.git"
	KEYWORDS=""
else
	SRC_URI="https://github.com/michaelwillis/dragonfly-reverb/releases/download/${PV}/DragonflyReverb-Source-v${PV}.tar.gz"
	KEYWORDS="~amd64"
	S="${WORKDIR}/DragonflyReverb-Source-v${PV}"
fi
LICENSE="GPL-3"
SLOT="0"
IUSE="standalone"
RESTRICT=mirror

RDEPEND="x11-libs/libX11
virtual/opengl
standalone? ( virtual/jack )
"

DOCS=( README.md )

src_prepare() {
	default

	# Remove automagic deps
	sed -i -re '/^HAVE_(CAIRO|OPENGL|X11|JACK|LIBLO)/d' dpf/Makefile.base.mk || die 'sed failed'
}

src_configure() {
	echo "Nothing to configure"
}

src_compile() {
	# The plugin claims to support using system Freeverb3, but then goes on to
	# use bundled headers instead of system headers. This is a recipe for
	# ABI disaster. Since this is a reverb plugin anyway, using a separately
	# versioned freeverb seems like more likely to run into compat trouble, so
	# let's just stick to the bundled version.
	emake \
		SYSTEM_FREEVERB3=false \
		HAVE_OPENGL=true \
		HAVE_X11=true \
		SKIP_STRIPPING=true \
		HAVE_JACK=$(usex standalone true false)
}

src_install() {
	einstalldocs

	cd "${S}/bin"

	use standalone && dobin $(ls -d Dragonfly* | grep -v '\.')

	exeinto "/usr/$(get_libdir)/vst"
	doexe Dragonfly*-vst.so

	for i in Dragonfly*.lv2; do
		exeinto "/usr/$(get_libdir)/lv2/${i}"
		insinto "/usr/$(get_libdir)/lv2/${i}"
		doexe "${i}"/*.so
		doins "${i}"/*.ttl
	done
}
