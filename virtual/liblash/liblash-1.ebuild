# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

DESCRIPTION="Virtual for LASH library"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="python"

DEPEND=""
RDEPEND="|| ( media-sound/lash-original media-sound/ladish[lash] )
	python? ( || ( media-sound/lash-original[python] media-sound/ladish[python] ) )"
