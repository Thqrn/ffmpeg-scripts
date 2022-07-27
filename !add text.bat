:: This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
:: This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
:: You should have received a copy of the GNU General Public License along with this program. If not, see http://www.gnu.org/licenses/.

:: made by Frost#5872
:: https://github.com/Thqrn/ffmpeg-scripts
@echo off
set "toptext= "
set /p toptext=Top text: 
set "bottomtext= "
set /p bottomtext=Bottom text: 
set "toptext=%toptext: =SPACEHERE%"
set "bottomtext=%bottomtext: =SPACEHERE%"
SET mypath=%~dp0
for %%a in (%*) do (
    call :addtext %%a %toptext% %bottomtext%
)
where /q ffplay || exit
if not exist "C:\Windows\Media\notify.wav" (exit) else ffplay "C:\Windows\Media\notify.wav" -volume 50 -autoexit -showmode 0 -loglevel quiet
exit


:addtext
set inputvideo=%1
ffprobe -v error -select_streams v:0 -show_entries stream=width -i %inputvideo% -of csv=p=0 > %temp%\width.txt
ffprobe -v error -select_streams v:0 -show_entries stream=height -i %inputvideo% -of csv=p=0 > %temp%\height.txt
set /p height=<%temp%\height.txt
set /p width=<%temp%\width.txt
set toptext=%2
set bottomtext=%3
set "toptext=%toptext:SPACEHERE= %"
set "bottomtext=%bottomtext:SPACEHERE= %"
set toptextnospace=%toptext: =_%
echo "%toptextnospace%" > %temp%\toptext.txt
set /p toptextnospace=<%temp%\toptext.txt
for %%? in (%temp%\toptext.txt) do ( set /A strlength=%%~z? - 2 )
if %strlength% LSS 16 set strlength=16
set /a fontsize=(%width%/%strlength%)*2
set toptext=%toptext:"=%
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
ffmpeg -hide_banner -loglevel error -stats -i %inputvideo% -shortest -c:v libx264 -c:a copy -vf "%textfilter%" -preset fast "%~dpn1 added text.mp4"
goto :eof