 [31;01m*[0m ERROR: media-sound/cadence-9999-r7::audio-overlay failed (depend phase):
 [31;01m*[0m   python-single-r1: EAPI 6 not supported
 [31;01m*[0m 
 [31;01m*[0m Call stack:
 [31;01m*[0m                 ebuild.sh, line 609:  Called source '/usr/local/portage/media-sound/cadence/cadence-9999-r7.ebuild'
 [31;01m*[0m    cadence-9999-r7.ebuild, line   7:  Called inherit 'git-r3' 'python-single-r1' 'gnome2-utils'
 [31;01m*[0m                 ebuild.sh, line 314:  Called __qa_source '/var/db/repos/gentoo/eclass/python-single-r1.eclass'
 [31;01m*[0m                 ebuild.sh, line 112:  Called source '/var/db/repos/gentoo/eclass/python-single-r1.eclass'
 [31;01m*[0m   python-single-r1.eclass, line  42:  Called die
 [31;01m*[0m The specific snippet of code:
 [31;01m*[0m   	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
 [31;01m*[0m 
 [31;01m*[0m If you need support, post the output of `emerge --info '=media-sound/cadence-9999-r7::audio-overlay'`,
 [31;01m*[0m the complete build log and the output of `emerge -pqv '=media-sound/cadence-9999-r7::audio-overlay'`.
 [31;01m*[0m Working directory: '/usr/lib/python3.7/site-packages'
 [31;01m*[0m S: '/var/tmp/portage/media-sound/cadence-9999-r7/work/cadence-9999'
Traceback (most recent call last):
  File "/usr/local/bin/overlay-packagelist", line 47, in <module>
    description, homepage_url = portdb.aux_get(versions[-1], ["DESCRIPTION", "HOMEPAGE"])
  File "/usr/lib/python3.7/site-packages/portage/dbapi/porttree.py", line 619, in aux_get
    myrepo=myrepo, loop=loop))
  File "/usr/lib/python3.7/site-packages/portage/util/_eventloop/EventLoop.py", line 833, in run_until_complete
    return future.result()
portage.exception.PortageKeyError: 'media-sound/cadence-9999-r7'
