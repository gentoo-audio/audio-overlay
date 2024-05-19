# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
inherit meson python-any-r1

DESCRIPTION="Minimal portable API for embeddable GUIs"
HOMEPAGE="https://github.com/lv2/pugl"

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/lv2/pugl.git"
else
	PUGL_COMMIT=
	SRC_URI="https://github.com/lv2/pugl/archive/${PUGL_COMMIT}.tar.gz -> ${P}.gh.tar.gz"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${PUGL_COMMIT}"
fi

LICENSE="ISC"
# subslot is SONAME version
SLOT="0/0.5.3"
IUSE="cairo doc opengl vulkan"

RDEPEND="
	x11-libs/libX11
	x11-libs/libXcursor
	x11-libs/libXext
	x11-libs/libXrandr

	cairo? ( x11-libs/cairo )
	opengl? ( virtual/opengl )
	vulkan? ( media-libs/vulkan-loader )
"
DEPEND="${RDEPEND}"
# shellcheck disable=SC2016
BDEPEND="
	doc? (
		app-text/doxygen

		$(python_gen_any_dep '
			dev-python/sphinx-lv2-theme[${PYTHON_USEDEP}]
			dev-python/sphinx[${PYTHON_USEDEP}]
			dev-python/sphinxygen[${PYTHON_USEDEP}]
		')
	)
"

# Tests don't work in the sandbox
RESTRICT="test"

python_check_deps() {
	! use doc || \
		python_has_version "dev-python/sphinx-lv2-theme[${PYTHON_USEDEP}]" \
		&& python_has_version "dev-python/sphinx[${PYTHON_USEDEP}]" \
		&& python_has_version "dev-python/sphinxygen[${PYTHON_USEDEP}]"
}

src_configure() {
	local emesonargs=(
		"$(meson_feature cairo)"
		"$(meson_feature doc docs)"
		"$(meson_use doc docs_cpp)"
		"$(meson_feature opengl)"
		"$(meson_feature vulkan)"

		-Dxcursor=enabled
		-Dxsync=enabled
		-Dxrandr=enabled

		-Dexamples=disabled
		-Dlint=false
		-Dtests=disabled
	)
	meson_src_configure
}
