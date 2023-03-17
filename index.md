Gentoo overlay containing audio production applications

## We're looking for maintainers!
This overlay is looking for maintainers.
If you use this overlay and would like to (help) maintain it, please post a message in [this issue](https://github.com/gentoo-audio/audio-overlay/issues/507).

## How to use this overlay
- If you manage [`/etc/portage/repos.conf`](https://wiki.gentoo.org/wiki//etc/portage/repos.conf) manually add the following entry:
```ini
[audio-overlay]
location = /<path>/<to>/<your>/<overlays>/audio-overlay
sync-type = git
sync-uri = https://github.com/gentoo-audio/audio-overlay.git
auto-sync = yes
```
- If you use [eselect repository](https://wiki.gentoo.org/wiki/Eselect/Repository) enable this overlay using:
```
eselect repository enable audio-overlay
```

## Contact
Join us at the `#audio-overlay` channel at `irc.libera.chat` or [create an issue](https://github.com/gentoo-audio/audio-overlay/issues/new).

## Packages

### media-libs

#### libmonome
Homepage: []()<br>
<br>
Available versions: `1.4.3`, `9999`

#### pyliblo
Homepage: [das.nasophon.de/pyliblo](http://das.nasophon.de/pyliblo)<br>
A Python wrapper for the liblo OSC library<br>
Available versions: `0.10.0-r2`


### media-plugins

#### adlplug
Homepage: [github.com/jpcima/ADLplug](https://github.com/jpcima/ADLplug)<br>
FM synthesizer plugin based on OPL3 sound chip emulation<br>
Available versions: `1.0.2`, `9999`

#### artyfx
Homepage: [openavproductions.com/artyfx](http://openavproductions.com/artyfx)<br>
Plugin bundle of artistic real-time audio effects<br>
Available versions: `1.3-r1`, `1.3.1`, `9999`

#### bitrot
Homepage: []()<br>
<br>
Available versions: `9999`

#### deteriorate-lv2
Homepage: []()<br>
<br>
Available versions: `1.0.7-r2`, `9999`

#### distrho-ports
Homepage: [github.com/DISTRHO/DISTRHO-Ports](https://github.com/DISTRHO/DISTRHO-Ports)<br>
Linux ports of Distrho plugins<br>
Available versions: `20201227`, `20210115`, `99999999`

#### dragonfly-reverb
Homepage: [github.com/michaelwillis/dragonfly-reverb](https://github.com/michaelwillis/dragonfly-reverb)<br>
A set of free reverb effects<br>
Available versions: `3.2.1`, `3.2.3`, `9999`

#### fabla
Homepage: [openavproductions.com/fabla2](http://openavproductions.com/fabla2)<br>
LV2 drum sampler plugin<br>
Available versions: `1.3.2-r1`, `1.9999`, `2.9999`

#### mverb
Homepage: [distrho.sourceforge.io/ports.php](https://distrho.sourceforge.io/ports.php)<br>
Studio quality, open-source reverb<br>
Available versions: `9999`

#### nekobi
Homepage: [distrho.sourceforge.io/plugins.php](https://distrho.sourceforge.io/plugins.php)<br>
Simple single-oscillator synth based on the Roland TB-303<br>
Available versions: `9999`

#### opnplug
Homepage: [github.com/jpcima/ADLplug](https://github.com/jpcima/ADLplug)<br>
FM synthesizer plugin based on OPN2 sound chip emulation<br>
Available versions: `1.0.2`, `9999`

#### sorcer
Homepage: [openavproductions.com/sorcer](http://openavproductions.com/sorcer)<br>
Polyphonic wavetable synth LV2 plugin<br>
Available versions: `1.1.3-r1`, `9999`


### media-sound

#### bitwig-studio
Homepage: [bitwig.com](http://bitwig.com)<br>
Multi-platform music-creation system for production, performance and DJing<br>
Available versions: `1.3.16`, `2.5.1`, `3.0.3`, `3.1.3`, `3.2.8`, `3.3.11`, `4.0.8`

#### cadence
Homepage: []()<br>
<br>
Available versions: `9999-r7`

#### carla
Homepage: [kxstudio.linuxaudio.org/Applications:Carla](http://kxstudio.linuxaudio.org/Applications:Carla)<br>
Fully-featured audio plugin host, supports many audio drivers and plugin formats<br>
Available versions: `2.2.0`, `2.5.2`, `9999-r1`

#### drumkv1
Homepage: [drumkv1.sourceforge.net/](http://drumkv1.sourceforge.net/)<br>
An old-school all-digital drum-kit sampler synthesizer with stereo fx<br>
Available versions: `0.9.18`, `0.9.19`, `0.9.21`, `9999-r1`

#### ladish
Homepage: []()<br>
<br>
Available versions: `1-r2`, `9999`

#### luppp
Homepage: [openavproductions.com/luppp](http://openavproductions.com/luppp)<br>
Live performance looping tool<br>
Available versions: `1.2.1`, `9999`

#### new-session-manager
Homepage: [github.com/linuxaudio/new-session-manager](https://github.com/linuxaudio/new-session-manager)<br>
A tool to assist music production by grouping standalone programs into sessions<br>
Available versions: `1.4.0`, `1.5.0`, `9999`

#### padthv1
Homepage: [padthv1.sourceforge.net](http://padthv1.sourceforge.net)<br>
Old-school polyphonic additive synthesizer<br>
Available versions: `0.9.18`, `0.9.19`, `0.9.21`, `9999-r1`

#### pure-data
Homepage: [msp.ucsd.edu/software.html](http://msp.ucsd.edu/software.html)<br>
Visual programming language for multimedia<br>
Available versions: `0.51.3`, `0.51.4`, `9999`

#### samplv1
Homepage: [samplv1.sourceforge.io](http://samplv1.sourceforge.io)<br>
Old-school polyphonic sampler<br>
Available versions: `0.9.18`, `0.9.19`, `0.9.21`, `9999-r1`

#### sc3-plugins
Homepage: [github.com/supercollider/sc3-plugins](https://github.com/supercollider/sc3-plugins)<br>
Third party plugins for SuperCollider<br>
Available versions: `3.11.0`, `3.11.1`, `9999`

#### sequencer64
Homepage: [github.com/ahlstromcj/sequencer64](https://github.com/ahlstromcj/sequencer64)<br>
Reboot of seq24, a minimal loop based midi sequencer<br>
Available versions: `0.96.7`, `0.96.8`, `9999`

#### serialosc
Homepage: []()<br>
<br>
Available versions: `1.4.1`, `9999`

#### setbfree
Homepage: [setbfree.org](http://setbfree.org)<br>
MIDI controlled DSP tonewheel organ<br>
Available versions: `0.8.10`, `0.8.11-r1`, `9999`

#### synthv1
Homepage: [synthv1.sourceforge.net](http://synthv1.sourceforge.net)<br>
Old-school all-digital 4-oscillator subtractive polyphonic synthesizer<br>
Available versions: `0.9.18`, `0.9.19`, `0.9.21`, `9999-r1`


### x11-libs

#### ntk
Homepage: []()<br>
<br>
Available versions: `1.3.1001`, `9999`


