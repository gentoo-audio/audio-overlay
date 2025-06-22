 [31;01m*[0m ERROR: media-libs/pyliblo-0.10.0-r2::audio-overlay failed (depend phase):
 [31;01m*[0m   distutils-r1: EAPI 7 not supported
 [31;01m*[0m 
 [31;01m*[0m Call stack:
 [31;01m*[0m                  ebuild.sh, line 609:  Called source '/usr/local/portage/media-libs/pyliblo/pyliblo-0.10.0-r2.ebuild'
 [31;01m*[0m   pyliblo-0.10.0-r2.ebuild, line   8:  Called inherit 'distutils-r1'
 [31;01m*[0m                  ebuild.sh, line 314:  Called __qa_source '/var/db/repos/gentoo/eclass/distutils-r1.eclass'
 [31;01m*[0m                  ebuild.sh, line 112:  Called source '/var/db/repos/gentoo/eclass/distutils-r1.eclass'
 [31;01m*[0m        distutils-r1.eclass, line 221:  Called die
 [31;01m*[0m The specific snippet of code:
 [31;01m*[0m   	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
 [31;01m*[0m 
 [31;01m*[0m If you need support, post the output of `emerge --info '=media-libs/pyliblo-0.10.0-r2::audio-overlay'`,
 [31;01m*[0m the complete build log and the output of `emerge -pqv '=media-libs/pyliblo-0.10.0-r2::audio-overlay'`.
 [31;01m*[0m Working directory: '/usr/lib/python3.7/site-packages'
 [31;01m*[0m S: '/var/tmp/portage/media-libs/pyliblo-0.10.0-r2/work/pyliblo-0.10.0'
Traceback (most recent call last):
  File "/usr/local/bin/overlay-packagelist", line 47, in <module>
    description, homepage_url = portdb.aux_get(versions[-1], ["DESCRIPTION", "HOMEPAGE"])
  File "/usr/lib/python3.7/site-packages/portage/dbapi/porttree.py", line 619, in aux_get
    myrepo=myrepo, loop=loop))
  File "/usr/lib/python3.7/site-packages/portage/util/_eventloop/EventLoop.py", line 833, in run_until_complete
    return future.result()
portage.exception.PortageKeyError: 'media-libs/pyliblo-0.10.0-r2'
