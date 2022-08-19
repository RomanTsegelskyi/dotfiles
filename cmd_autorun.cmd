@if "%overbose%" == "" echo off

rem ohome
DOSKEY oc=ohome clean
DOSKEY obd=obuild x64 debug
DOSKEY ce=oclient -c "-o *; - *; +otools; +buildtest; w; f; w; q" ^& ohome clean sync

DOSKEY ocs=ohome clean sync
DOSKEY ohd=ohome ohomedebug
DOSKEY ohb=ohome build x64 debug
DOSKEY ohbp=ohome build x64 debug $1
DOSKEY os=osync

rem oclient
DOSKEY oce=oclient -c "+$1; w; ;f; q;"
DOSKEY ocu=oclient -c "-$1; w; ;f; q;"
DOSKEY ce=oclient -c "-o *; - *; +otools; w; f; q" ^& ohome clean sync

rem settings and aliases
DOSKEY us=ROBOCOPY "E:\\toolsettings" "C:\\Users\\romants\\AppData\\Roaming"
DOSKEY al=subl E:\toolsettings\aliases.cmd

rem sublime
DOSKEY st=subl $1
DOSKEY sn=subl $1
DOSKEY np=subl $1

rem open
DOSKEY s=start $1
DOSKEY sc=start .

rem BB
DOSKEY bbosync=bb local -config dev-win2012r2 -m client:romants-$1  -tests -to 375875 $2 $3
DOSKEY bbhotsync=bb local -config dev-win2012r2 -m client:romants-$1  -tests -to 371725 $2 $3
DOSKEY bboclient=bb local -config dev-win2012r2 -m client:romants-$1  -tests -to 371729 $2 $3
DOSKEY bboint1=bb local -config dev-win2012r2 -m client:romants-$1  -tests -to 377745 $2 $3
DOSKEY bboint2=bb local -config dev-win2012r2 -m client:romants-$1  -tests -to 377746 $2 $3
DOSKEY bbgitbridge=bb local -config dev-win2012r2 -m client:romants-$1  -tests -to 381678 $2 $3

rem Change to directories
DOSKEY cl1=cd D:\Office\dev
DOSKEY cl2=cd D:\Office1\dev
DOSKEY cl3=cd D:\Office2\dev

rem Misc
DOSKEY rrf=rm -rf $1

rem Git
DOSKEY grib=rm -rf $1 ^& mkdir $1 ^& git init --bare $1

rem SD specific
DOSKEY swd=sd sync ...
DOSKEY sf=sd sync $1
DOSKEY rwd=sd revert ...
DOSKEY rf=sd revert $1
DOSKEY sdo=sd opened
DOSKEY sdc=sd change
DOSKEY sdcs=sdv changes $1
DOSKEY sdest=sd edit $1 ^& subl $1

rem debugger
DOSKEY pd=setperl d $1

rem vs
DOSKEY de=devenv $1

rem set some environment variables
set git_noaria=1

rem start clink
"%CLINK_DIR%\clink.bat" inject
