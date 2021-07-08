# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_RUBY="ruby25 ruby26 ruby27"
PYTHON_COMPAT=( python{2_7,3_6,3_7,3_8,3_9} )
PYTHON_REQ_USE='threads(+)'

inherit bash-completion-r1 ruby-single python-any-r1

DESCRIPTION="Zyn-Fusion User Interface"
HOMEPAGE="https://github.com/mruby-zest/mruby-zest-build"

SUBMODULES=(
	"4f57a1ef9f968e9d5eef53667c7960a2e98c9750 deps/mruby-complex https://github.com/pbosetti/mruby-complex"
	"334c040a2e2c4c2689f8c3440168011f64d57ada deps/mruby-dir-glob https://github.com/gromnitsky/mruby-dir-glob"
	"6849202f885516b381406e799dcdb430065e19cf deps/mruby-glew https://github.com/IceDragon200/mruby-glew"
	"0eeee012fd4bbd6544dd34f17ce2b476ad71d86b deps/mruby-glfw3 https://github.com/IceDragon200/mruby-glfw3"
	"1c4428880b2f0f0fcd81ea2debc5f4459a7ed53c deps/mruby-io https://github.com/iij/mruby-io"
	"d7d4e1ce434131babb5fd6026201011f5b0b50ea deps/mruby-nanovg https://github.com/mruby-zest/mruby-nanovg"
	"cd13fb15fd6b813fc6c9bc2f17db20257f71bb0c deps/mruby-regexp-pcre https://github.com/iij/mruby-regexp-pcre"
	"68334311ac7386eef84f3034a256e7135a87625d deps/mruby-set https://github.com/yui-knk/mruby-set"
	"263d70351a4f75a875f2a35ab9a9128d1ef5da90 deps/mruby-sleep https://github.com/matsumoto-r/mruby-sleep"
	"b83cf926525e7cea8d2483da2a75852b8c7b6d28 deps/nanovg https://github.com/memononen/nanovg"
	"d87062625ed652df9455bd6f60ea89c53515c43a deps/pugl https://github.com/mruby-zest/pugl"
	"70307782622c668a325992f6887f354ca30d5e14 deps/rtosc https://github.com/fundamental/rtosc"
	"e5b61d34f65cabfbe88f3f1709a1f9cff86585de mruby https://github.com/mruby/mruby"
	"a3e687124b5afe51cdc4d8d36cbff7204e81a1b4 src/mruby-qml-parse https://github.com/mruby-zest/mruby-qml-parse"
	"77f782643c78a9cfe48e49f027d9978fb5e27d77 src/mruby-qml-spawn https://github.com/mruby-zest/mruby-qml-spawn"
	"8352b7ae4a0efba111f72572d993efb892a27761 src/mruby-zest https://github.com/mruby-zest/mruby-zest"
	"67b0b5c85e0072ea0bee1129a1ec8cef1328faaa src/osc-bridge https://github.com/mruby-zest/osc-bridge"
	"2033837203c8a141b1f9d23bb781fe0cbaefbd24 mruby/build/mrbgems/mgem-list https://github.com/mruby/mgem-list"
	"89dceefa1250fb1ae868d4cb52498e9e24293cd1 mruby/build/mrbgems/mruby-dir https://github.com/iij/mruby-dir"
	"383a9c79e191d524a9a2b4107cc5043ecbf6190b mruby/build/mrbgems/mruby-pack https://github.com/iij/mruby-pack"
	"b4415207ff6ea62360619c89a1cff83259dc4db0 mruby/build/mrbgems/mruby-errno https://github.com/iij/mruby-errno"
	"d196a1e529d227511cf19d516a46f62866619008 mruby/build/mrbgems/mruby-file-stat https://github.com/ksss/mruby-file-stat"
	"95da206a5764f4e80146979b8e35bd7a9afd6850 mruby/build/mrbgems/mruby-process https://github.com/iij/mruby-process"
)

SRC_URI="https://github.com/mruby-zest/mruby-zest-build/archive/${PV}.tar.gz -> ${P}.tar.gz"
for i in "${SUBMODULES[@]}"; do
	set -- $i
	SRC_URI+=" $3/archive/$1.tar.gz -> ${3/*\//}-$1.tar.gz"
done

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-libs/libuv
	x11-libs/libX11
	x11-libs/libxcb
	virtual/opengl"
RDEPEND="${DEPEND}"
BDEPEND="${RUBY_DEPS}
${PYTHON_DEPS}"

S="${WORKDIR}/mruby-zest-build-$PV"

PATCHES=(
"${FILESDIR}/zyn-fusion-gcc10.patch"
"${FILESDIR}/zyn-fusion-qml-path.patch"
)

src_prepare() {
	# Unbundle libuv: makefile and rake file
	sed -i -e "s%./deps/\$(UV_DIR)/.libs/libuv.a%`pkg-config --libs libuv`%" \
		-e 's%-I ../../deps/\$(UV_DIR)/include%-I /usr/include/uv/%' Makefile
	sed -i -e "/deps\/libuv.a/s/<< .*/<< \"`pkg-config --libs libuv`\"/" \
		-e 's%../deps/libuv-v1.9.1/include/%usr/include/uv/%' build_config.rb

	for i in "${SUBMODULES[@]}"; do
		set -- $i
		mkdir -p "$2"
		rmdir "$2"
		mv "../${3/*\//}-$1" "$2"
	done

	# fix jobserver, make rake use MAKEOPTS too, give it a soname,
	# say no to python2, use LDFLAGS/CFLAGS
	sed -i -e 's/\bmake\b/$(MAKE)/' \
		-e "s/\brake\b/rake ${MAKEOPTS}/" \
		-e 's/-shared/$(LDFLAGS) -shared -Wl,-soname,libzest.so/' \
		-e "s/python2/${EPYTHON}/" \
		-e "s/--debug//" \
		-e 's/CFLAGS="/CFLAGS="$(CFLAGS) /' \
		-e 's/$(CC)/$(CC) $(CFLAGS)/' Makefile

	default_src_prepare

	# bundled waf is broken in Python3.7, and this is a version with
	# autowaf, so it isn't trivial to just replace with upstream.
	# Hack around it instead.
	${EPYTHON} deps/pugl/waf --version # This will unpack waf
	# Now fix it
	sed -i -e '/StopIteration/d' deps/pugl/.waf*/waflib/Node.py
}

src_install() {
	insinto /usr/share/zyn-fusion/qml
	doins src/mruby-zest/qml/*
	doins src/mruby-zest/example/*

	insinto /usr/share/zyn-fusion/schema
	doins src/osc-bridge/schema/test.json

	insinto /usr/share/zyn-fusion/font
	doins deps/nanovg/example/*.ttf

	dolib.so libzest.so
	dobin zest
	dosym zest /usr/bin/zyn-fusion
	dobashcomp completions/zyn-fusion
	bashcomp_alias zyn-fusion zest
}
