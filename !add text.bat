@echo off

set inputvideo=%1
ffprobe -v error -select_streams v:0 -show_entries stream=width -i %inputvideo% -of csv=p=0 > %temp%\width.txt
ffprobe -v error -select_streams v:0 -show_entries stream=height -i %inputvideo% -of csv=p=0 > %temp%\height.txt
set /p height=<%temp%\height.txt
set /p width=<%temp%\width.txt

set "toptext= "
set /p toptext=Top text: 
set toptextnospace=%toptext: =_%
echo "%toptextnospace%" > %temp%\toptext.txt
set /p toptextnospace=<%temp%\toptext.txt
for %%? in (%temp%\toptext.txt) do ( set /A strlength=%%~z? - 2 )
if %strlength% LSS 16 set strlength=16
set /a fontsize=(%width%/%strlength%)*2
set toptext=%toptext:"=%

set "bottomtext= "
set /p bottomtext=Bottom text: 
set bottomtextnospace=%bottomtext: =_%
echo "%bottomtextnospace%" > %temp%\bottomtext.txt
set /p bottomtextnospace=<%temp%\bottomtext.txt
for %%? in (%temp%\bottomtext.txt) do ( set /A strlengthb=%%~z? - 2 )
if %strlengthb% LSS 16 set strlengthb=16
set /a fontsizebottom=(%width%/%strlengthb%)*2
set bottomtext=%bottomtext:"=%

set "textfilter=drawtext=borderw=(%fontsize%/12):fontfile=C\\:/Windows/Fonts/impact.ttf:text='%toptext%':fontcolor=white:fontsize=%fontsize%:x=(w-text_w)/2:y=(0.25*text_h),drawtext=borderw=(%fontsizebottom%/12):fontfile=C\\:/Windows/Fonts/impact.ttf:text='%bottomtext%':fontcolor=white:fontsize=%fontsizebottom%:x=(w-text_w)/2:y=(h-1.25*text_h)"

if exist "%temp%\toptext.txt" (del "%temp%\toptext.txt")
if exist "%temp%\bottomtext.txt" (del "%temp%\bottomtext.txt")
if exist "%temp%\width.txt" (del "%temp%\width.txt")
if exist "%temp%\height.txt" (del "%temp%\height.txt")

ffmpeg -hide_banner -loglevel error -stats -i %inputvideo% -shortest -vf "%textfilter%" "%~dpn1 added text.mp4"