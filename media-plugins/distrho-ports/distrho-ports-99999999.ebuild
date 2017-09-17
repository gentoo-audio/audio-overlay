# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3

DESCRIPTION="Linux ports of Distrho plugins."
HOMEPAGE="http://distrho.sourceforge.net"
EGIT_REPO_URI="https://github.com/DISTRHO/DISTRHO-Ports.git"
KEYWORDS=""
LICENSE="GPL-2"
SLOT="0"

IUSE="lv2 vst"
REQUIRED_USE="|| ( lv2 vst )"

RDEPEND="media-libs/alsa-lib
	media-libs/freetype
	media-libs/ladspa-sdk
	virtual/opengl
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXcursor
	x11-libs/libXrender"
DEPEND="${RDEPEND}
	dev-util/premake:3"

QA_PRESTRIPPED="
	/usr/lib/lv2/Luftikus.lv2/Luftikus.so
	/usr/lib/lv2/drowaudio-reverb.lv2/drowaudio-reverb.so
	/usr/lib/lv2/Obxd.lv2/Obxd.so
	/usr/lib/lv2/TAL-NoiseMaker.lv2/TAL-NoiseMaker.so
	/usr/lib/lv2/TheFunction.lv2/TheFunction.so
	/usr/lib/lv2/TAL-Vocoder-2.lv2/TAL-Vocoder-2.so
	/usr/lib/lv2/drowaudio-distortionshaper.lv2/drowaudio-distortionshaper.so
	/usr/lib/lv2/TAL-Dub-3.lv2/TAL-Dub-3.so
	/usr/lib/lv2/Vex.lv2/Vex.so
	/usr/lib/lv2/LUFSMeter.lv2/LUFSMeter.so
	/usr/lib/lv2/PitchedDelay.lv2/PitchedDelay.so
	/usr/lib/lv2/drowaudio-flanger.lv2/drowaudio-flanger.so
	/usr/lib/lv2/Dexed.lv2/Dexed.so
	/usr/lib/lv2/Wolpertinger.lv2/Wolpertinger.so
	/usr/lib/lv2/drowaudio-distortion.lv2/drowaudio-distortion.so
	/usr/lib/lv2/EasySSP.lv2/EasySSP.so
	/usr/lib/lv2/LUFSMeterMulti.lv2/LUFSMeterMulti.so
	/usr/lib/lv2/StereoSourceSeparation.lv2/StereoSourceSeparation.so
	/usr/lib/lv2/ThePilgrim.lv2/ThePilgrim.so
	/usr/lib/lv2/KlangFalter.lv2/KlangFalter.so
	/usr/lib/lv2/TAL-Reverb-3.lv2/TAL-Reverb-3.so
	/usr/lib/lv2/TAL-Reverb.lv2/TAL-Reverb.so
	/usr/lib/lv2/drowaudio-tremolo.lv2/drowaudio-tremolo.so
	/usr/lib/lv2/TAL-Filter-2.lv2/TAL-Filter-2.so
	/usr/lib/lv2/eqinox.lv2/eqinox.so
	/usr/lib/lv2/drumsynth.lv2/drumsynth.so
	/usr/lib/lv2/TAL-Filter.lv2/TAL-Filter.so
	/usr/lib/lv2/JuceDemoPlugin.lv2/JuceDemoPlugin.so
	/usr/lib/lv2/TAL-Reverb-2.lv2/TAL-Reverb-2.so"

src_prepare() {
	default
	scripts/premake-update.sh linux
}

src_compile() {
	if use lv2; then
		emake lv2
	fi
	if use vst; then
		emake vst
	fi
}

src_install() {
	emake DESTDIR="${D}" PREFIX="/usr" install
	if use !lv2; then
		rm -rf "${D}"/usr/lib/lv2
	fi
	if use !vst; then
		rm -rf "${D}"/usr/lib/vst
	fi
	rm -rf "${D}"/usr/src
}
