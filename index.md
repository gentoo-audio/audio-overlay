 [31;01m*[0m ERROR: media-plugins/deteriorate-lv2-9999::audio-overlay failed (depend phase):
 [31;01m*[0m   No supported implementation in PYTHON_COMPAT.
 [31;01m*[0m 
 [31;01m*[0m Call stack:
 [31;01m*[0m                     ebuild.sh, line 609:  Called source '/usr/local/portage/media-plugins/deteriorate-lv2/deteriorate-lv2-9999.ebuild'
 [31;01m*[0m   deteriorate-lv2-9999.ebuild, line  10:  Called inherit 'python-any-r1' 'waf-utils'
 [31;01m*[0m                     ebuild.sh, line 314:  Called __qa_source '/var/db/repos/gentoo/eclass/python-any-r1.eclass'
 [31;01m*[0m                     ebuild.sh, line 112:  Called source '/var/db/repos/gentoo/eclass/python-any-r1.eclass'
 [31;01m*[0m          python-any-r1.eclass, line 205:  Called _python_any_set_globals
 [31;01m*[0m          python-any-r1.eclass, line 176:  Called _python_set_impls
 [31;01m*[0m        python-utils-r1.eclass, line 158:  Called die
 [31;01m*[0m The specific snippet of code:
 [31;01m*[0m   			die "No supported implementation in PYTHON_COMPAT."
 [31;01m*[0m 
 [31;01m*[0m If you need support, post the output of `emerge --info '=media-plugins/deteriorate-lv2-9999::audio-overlay'`,
 [31;01m*[0m the complete build log and the output of `emerge -pqv '=media-plugins/deteriorate-lv2-9999::audio-overlay'`.
 [31;01m*[0m Working directory: '/usr/lib/python3.7/site-packages'
 [31;01m*[0m S: '/var/tmp/portage/media-plugins/deteriorate-lv2-9999/work/deteriorate-lv2-9999'
Traceback (most recent call last):
  File "/usr/local/bin/overlay-packagelist", line 47, in <module>
    description, homepage_url = portdb.aux_get(versions[-1], ["DESCRIPTION", "HOMEPAGE"])
  File "/usr/lib/python3.7/site-packages/portage/dbapi/porttree.py", line 619, in aux_get
    myrepo=myrepo, loop=loop))
  File "/usr/lib/python3.7/site-packages/portage/util/_eventloop/EventLoop.py", line 833, in run_until_complete
    return future.result()
portage.exception.PortageKeyError: 'media-plugins/deteriorate-lv2-9999'
