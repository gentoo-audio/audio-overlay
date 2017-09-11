# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

PYTHON_COMPAT=( python2_7 )

inherit autotools eutils python-single-r1 multilib-minimal

MY_PV="${PV/_/~}"
MY_PN="${PN/-original/}"
MY_P="${MY_PN}-${MY_PV}"

DESCRIPTION="LASH Audio Session Handler"
HOMEPAGE="http://www.nongnu.org/lash/"
SRC_URI="http://download.savannah.gnu.org/releases/${MY_PN}/${MY_P}.tar.bz2"
RESTRICT="mirror"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="alsa debug gtk python static-libs"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="dev-libs/libxml2
	virtual/jack
	>=sys-apps/util-linux-2.24.1-r3[${MULTILIB_USEDEP}]
	alsa? ( media-libs/alsa-lib )
	gtk? ( x11-libs/gtk+:2 )
	python? ( ${PYTHON_DEPS} )
	|| ( sys-libs/readline:* dev-libs/libedit )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	python? ( dev-lang/swig )"

S="${WORKDIR}/${MY_PN}-0.6.0.594"

PATCHES=(
	"${FILESDIR}"/${P}-aclocal.patch
	"${FILESDIR}"/${P}-include.patch
	"${FILESDIR}"/${P}-underlinking.patch
)

pkg_setup() {
	use python && python_single-r1_pkg_setup
}

src_prepare() {
	sed -i \
		-e '/texi2html/s:-number:&-sections:' \
		docs/Makefile.am || die #422045

	default
	AT_M4DIR=m4 eautoreconf
}

multilib_src_configure() {
	# Generation of docs does no longer work. Hard disable it.
	export ac_cv_prog_lash_texi2html="no" #422045

	local myeconf=()
	if ! multilib_is_native_abi || ! use python; then
		myconf+=( --without-python )
	fi

	if ! multilib_is_native_abi; then
		# disable remaining configure checks
		myconf+=(
			JACK_CFLAGS=' '
			JACK_LIBS=' '
			XML2_CFLAGS=' '
			XML2_LIBS=' '

			v1_cv_lib_readline=no
		)
	fi

	ECONF_SOURCE=${S}

	econf \
		$(use_enable static-libs static) \
		$(multilib_native_use_enable debug) \
		$(multilib_native_use_with alsa) \
		$(multilib_native_use_with gtk gtk2) \
		"${myconf[@]}"
}

multilib_src_compile() {
	if multilib_is_native_abi; then
		default
	else
		emake -C liblash
	fi
}

multilib_src_test() {
	multilib_is_native_abi && default
}

multilib_src_install() {
	if multilib_is_native_abi; then
		emake DESTDIR="${D}" install
	else
		# headers
		emake -C lash DESTDIR="${D}" install
		# library
		emake -C liblash DESTDIR="${D}" install
		# pkg-config
		emake DESTDIR="${D}" install-pkgconfogDATA
	fi
}

multilib_src_install_all() {
	prune_libtool_files --all # --all for _lash.la in python directory
	use python && python_optimize
}
