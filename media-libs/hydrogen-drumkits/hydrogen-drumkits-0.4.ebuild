# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="free drumkits for hydrogen"
HOMEPAGE="http://www.hydrogen-music.org"
SRC_URI="mirror://sourceforge/hydrogen/ForzeeStereo.h2drumkit
	mirror://sourceforge/hydrogen/3355606kit.h2drumkit
	 mirror://sourceforge/hydrogen/Boss_DR-110.h2drumkit
	 mirror://sourceforge/hydrogen/Classic-626.h2drumkit
	 mirror://sourceforge/hydrogen/Classic-808.h2drumkit
	 mirror://sourceforge/hydrogen/ColomboAcousticDrumkit.h2drumkit
	 mirror://sourceforge/hydrogen/DeathMetal.h2drumkit
	 mirror://sourceforge/hydrogen/EasternHop-1.h2drumkit
	 mirror://sourceforge/hydrogen/ElectricEmpireKit.h2drumkit
	 mirror://sourceforge/hydrogen/ErnysPercussion.h2drumkit
	 mirror://sourceforge/hydrogen/HardElectro1.h2drumkit
	 mirror://sourceforge/hydrogen/HipHop-1.h2drumkit
	 mirror://sourceforge/hydrogen/HipHop-2.h2drumkit
	 mirror://sourceforge/hydrogen/K-27_Trash_Kit.h2drumkit
	 mirror://sourceforge/hydrogen/Millo-Drums_v.1.h2drumkit
	 mirror://sourceforge/hydrogen/Millo_MultiLayered2.h2drumkit
	 mirror://sourceforge/hydrogen/Millo_MultiLayered3.h2drumkit
	 mirror://sourceforge/hydrogen/Synthie-1.h2drumkit
	 mirror://sourceforge/hydrogen/TD-7kit.h2drumkit
	 mirror://sourceforge/hydrogen/Techno-1.h2drumkit
	 mirror://sourceforge/hydrogen/TR808909.h2drumkit
	 mirror://sourceforge/hydrogen/VariBreaks.h2drumkit
	 mirror://sourceforge/hydrogen/circAfrique%20v4.h2drumkit
	 mirror://sourceforge/hydrogen/YamahaVintageKit.h2drumkit
	 mirror://sourceforge/hydrogen/BJA_Pacific.h2drumkit"
RESTRICT="mirror"

LICENSE="GPL-2 ZLIB"
SLOT="0"
KEYWORDS="~amd64"

IUSE=""

S="${WORKDIR}"

src_unpack(){
	cp "${DISTDIR}"/*.h2drumkit "${S}"
}

src_compile(){
	einfo "nothing to compile"
}

src_install(){
	insinto  /usr/share/hydrogen/data/drumkits/
	doins -r *.h2drumkit
}
