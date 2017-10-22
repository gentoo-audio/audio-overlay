# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils unpacker

PACKAGE_NAME="praxis-live"

DESCRIPTION="Hybrid visual IDE for creative coding"
HOMEPAGE="http://www.praxislive.org/"
SRC_URI="https://github.com/praxis-live/praxis-live/releases/download/v${PV}/${PACKAGE_NAME}_${PV}-1_all.deb"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror"
IUSE="+x264"

DEPEND=""
RDEPEND="${DEPEND}
	virtual/jdk
	media-libs/gstreamer
	x264? (
		media-libs/gst-plugins-good
		media-plugins/gst-plugins-x264
		media-plugins/gst-plugins-libav
	)
"

PATCHES=( "${FILESDIR}/${PN}-3.1.0-java_home.patch" )

S=${WORKDIR}

src_install(){

	# bin
	insinto /usr/lib/praxis-live/bin
	doins -r usr/lib/praxis-live/bin/{praxis,praxis_live}
	dodir usr/bin
	dosym ../lib/praxis-live/bin/praxis usr/bin/praxis
	dosym ../lib/praxis-live/bin/praxis_live usr/bin/praxis_live
	fperms +x /usr/lib/praxis-live/bin/praxis
	fperms +x /usr/lib/praxis-live/bin/praxis_live

	# lib
	insinto /usr/lib/praxis-live
	doins -r usr/lib/praxis-live/{etc,extide,ide,java,praxis,praxis_live}
	insinto /usr/lib/praxis-live/platform
	doins -r usr/lib/praxis-live/platform/{config,core,modules,update,update_tracking}
	insinto /usr/lib/praxis-live/platform/lib
	doins -r usr/lib/praxis-live/platform/lib/*.jar
	doins -r usr/lib/praxis-live/platform/lib/{locale,nbexec}

	# share
	insinto /usr/share
	doins -r usr/share/{applications,doc,icons}

	sed -i \
	-e 's/Icon=.*/Icon=praxis_live/' \
	-e 's/Categories=.*/Categories=AudioVideo;Audio;AudioVideoEditing/' \
	usr/share/applications/praxis_live.desktop || die 'sed on desktop file failed'
	domenu usr/share/applications/praxis_live.desktop
}
