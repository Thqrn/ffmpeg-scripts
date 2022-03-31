@echo off
:: change forcefps to true if you want the video to be force outputted to the value in forcedfpsvalue
set forcefps=false
set forcedfpsvalue=60

set inputvideo=%*
ffprobe -v error -select_streams v:0 -show_entries stream=r_frame_rate -i %inputvideo% -of csv=p=0 > %temp%\fps.txt
set /p fpsvalue=<%temp%\fps.txt
set /a fpsvalue=%fpsvalue%

set toptext=hiuhgIU8768768G67967hwgd73
set /p toptext=Top text: 
if "%toptext%" == "hiuhgIU8768768G67967hwgd73" set "toptext= "
set toptextnospace=%toptext: =_%
echo "%toptextnospace%" > %temp%\toptext.txt
set /p toptextnospace=<%temp%\toptext.txt
for %%? in (%temp%\toptext.txt) do ( set /A strlength=%%~z? - 2 )
if %strlength% LSS 16 set strlength=16
set /a halflength=%strlength%/4
set /a fontsize=750/%halflength%
set topypos=(0.25*text_h)
if %fontsize% GTR 240 set topypos=0
set toptext=%toptext:"=%

set bottomtext=OAUWGIU21i3g8972g48bh8976BHV
set /p bottomtext=Bottom text: 
if "%bottomtext%" == "OAUWGIU21i3g8972g48bh8976BHV" set "bottomtext= "
set bottomtextnospace=%bottomtext: =_%
echo "%bottomtextnospace%" > %temp%\bottomtext.txt
set /p bottomtextnospace=<%temp%\bottomtext.txt
for %%? in (%temp%\bottomtext.txt) do ( set /A strlength=%%~z? - 2 )
if %strlength% LSS 16 set strlength=16
set /a halflength=%strlength%/4
set /a fontsizebottom=750/%halflength%
set bottomypos=(h-1.25*text_h)
if %fontsizebottom% GTR 240 set bottomypos=(h-text_h)
set bottomtext=%bottomtext:"=%

set speedq=1
set /p speedq=Speed (leave blank for default, must be between 0.5 and 100): 
if %speedq% gtr 100 set speedq=100
if 1%speedq% == 1 set speedq=1
set speedfps=%forcedfpsvalue%
if %forcefps% == false set speedfps=%speedq%*%fpsvalue%
if %speedq% == 1 (
     set "af=-c:a copy"
	 set speedfilter= 
) else (
     set "af=-af atempo=%speedq%"
	 set speedfilter=,setpts=1/%speedq%*PTS,fps=%speedfps%
)

set "textfilter=drawtext=borderw=10:fontfile=C\\:/Windows/Fonts/impact.ttf:text='%toptext%':fontcolor=white:fontsize=%fontsize%:x=(w-text_w)/2:y=%topypos%,drawtext=borderw=10:fontfile=C\\:/Windows/Fonts/impact.ttf:text='%bottomtext%':fontcolor=white:fontsize=%fontsizebottom%:x=(w-text_w)/2:y=%bottomypos%"

if exist "%temp%\toptext.txt" (del "%temp%\toptext.txt")
if exist "%temp%\bottomtext.txt" (del "%temp%\bottomtext.txt")
if exist "%temp%\fps.txt" (del "%temp%\fps.txt")

ffmpeg -i %inputvideo% -shortest %af% -vf "%textfilter%%speedfilter%" "%~dpn1 added text.mp4"
exit