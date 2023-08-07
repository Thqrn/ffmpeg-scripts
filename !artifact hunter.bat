:: This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
:: This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
:: You should have received a copy of the GNU General Public License along with this program. If not, see http://www.gnu.org/licenses/.

:: Copyright 2023 Thqrn. Licensed under the GNU General Public License v3.0.

:: @froest on Discord
:: https://github.com/Thqrn/ffmpeg-scripts

:: made to (jokingly) spot artifacts in videos

:main
@echo off
setlocal enabledelayedexpansion
set version=1.0.1
title Artifact Hunter v%version%
set position=r
choice /m "[S]imple or [A]dvanced?" /c SA /n
if %errorlevel% == 2 call :advanced
set totalfiles=0
for %%x in (%*) do set /a totalfiles+=1
set filesdone=1
set ogscaleq=%scaleq%
for %%a in (%*) do (
    title [!filesdone!/%totalfiles%] Artifact Hunter v%version%
    set filesdoneold=!filesdone!
    set /a filesdone=!filesdone!+1
    call :render "%%~a"
    set scaleq=%ogscaleq%
)
title [Done] Artifact Hunter v%version%
where /q ffplay.exe || goto aftersound
start /min cmd /c ffplay "C:\Windows\Media\notify.wav" -volume 50 -autoexit -showmode 0 -loglevel quiet
:aftersound
pause
exit

:advanced
echo Size of cropped artifact relative to input (ex. 10 for an artifact 1/10 the size of the input dimensions):
echo Left blank for random.
set /p "scaleq="
echo Where to crop the image to:
choice /m "[R]andom, [F]ood Bar, [H]ealth and Armor Bar, or [C]rosshair" /n /c RFHC
if %errorlevel% == 2 (
    set position=f
)
if %errorlevel% == 3 (
    set position=h
)
if %errorlevel% == 4 (
    set position=c
)
call :textquestion
goto :eof

:render
if not defined scaleq set /a scaleq=%random% * 10 / 32768 + 3
ffprobe -v error -select_streams v:0 -count_packets -show_entries stream=nb_read_packets -i %1 -of csv=p=0 > %temp%\frames.txt
set /p frames=<%temp%\frames.txt
if exist "%temp%\frames.txt" (del "%temp%\frames.txt")
ffprobe -v error -select_streams v:0 -show_entries stream=width -i %1 -of csv=p=0 > %temp%\width.txt
ffprobe -v error -select_streams v:0 -show_entries stream=height -i %1 -of csv=p=0 > %temp%\height.txt
set /p height=<%temp%\height.txt
set /p width=<%temp%\width.txt
if exist "%temp%\height.txt" (del "%temp%\height.txt")
if exist "%temp%\width.txt" (del "%temp%\width.txt")
set /a desiredheight=%height%/%scaleq%
set /a desiredheight=(%desiredheight%/2)*2
set /a desiredwidth=%width%/%scaleq%
set /a desiredwidth=(%desiredwidth%/2)*2
call :textmath
set /a framenum=%random% * %frames% / 32768 + 0
set /a posx=%random% * ^(%width%-%desiredwidth%^) / 32768 + 0
set /a posy=%random% * ^(%height%-%desiredheight%^) / 32768 + 0
if %position% == f (
    set /a posx=^(^(%width%-%desiredwidth%^)/5^)+^(^(%width%-%desiredwidth%^)/3^)
    set /a posy=^(^(%height%^)/30^)*28-^(%desiredheight%/2^)
)
if %position% == h (
    set /a posx=^(^(%width%-%desiredwidth%^)/4^)+^(^(%width%-%desiredwidth%^)/6^)
    set /a posy=^(^(%height%^)/30^)*28-^(%desiredheight%^)
)
if %position% == c (
    set /a posx=^(%width%-%desiredwidth%^)/2
    set /a posy=^(%height%-%desiredheight%^)/2
)
set "filename=%~dpn1 (MAJOR ARTIFACT)"
if exist "%filename%.png" call :renamefile
echo.
if not %totalfiles% == 1 (
    echo [38;2;254;165;0m[%filesdoneold%/%totalfiles%] Encoding %~n1[0m
) else (
    echo [38;2;254;165;0mEncoding...[0m
)
if %frames% == 1 (
    ffmpeg -hide_banner -stats_period 0.05 -loglevel error -stats -i %1 -vf "crop=%desiredwidth%:%desiredheight%:%posx%:%posy%,%textfilter%" -c:v png "%filename%.png"
) else (
    ffmpeg -hide_banner -stats_period 0.05 -loglevel error -stats -i %1 -vf "select=eq(n\,%framenum%),crop=%desiredwidth%:%desiredheight%:%posx%:%posy%,%textfilter%" -frames:v 1 -c:v png "%filename%.png"
)
goto :eof

:renamefile
:: start of the repeat until loop (repeats until the file doesn't exist)
:renamefileloop
set /a "i+=1"
if exist "%filename% (%i%).png" goto renamefileloop
set "filename=%filename% (%i%)"
goto :eof

:textquestion
choice /c YN /m "Do you want to add text to the video?"
:: if yes, set the variable, if no, skip
if %errorlevel% == 2 goto :eof
set "toptext= "
set /p "toptext=Top text: "
set "bottomtext= "
set /p "bottomtext=Bottom text: "
goto :eof

:textmath
:: remove spaces and count the characters in the text
set toptextnospace=%toptext: =_%
echo "%toptextnospace%" > %temp%\toptext.txt
for %%? in (%temp%\toptext.txt) do ( set /a strlength=%%~z? - 2 )
if exist "%temp%\toptext.txt" (del "%temp%\toptext.txt")
:: if below 16 characters, set it to 16 (essentially caps the font size)
if %strlength% LSS 16 set strlength=16
:: bottom text
set bottomtextnospace=%bottomtext: =_%
echo "%bottomtextnospace%" > %temp%\bottomtext.txt
for %%? in (%temp%\bottomtext.txt) do ( set /a strlengthb=%%~z? - 2 )
if exist "%temp%\bottomtext.txt" (del "%temp%\bottomtext.txt")
if %strlengthb% LSS 16 set strlengthb=16
:: use width and size of the text, and the user's inputted text size to determine font size
set /a fontsize=(%desiredwidth%/%strlength%)*2
set /a fontsizebottom=(%desiredwidth%/%strlengthb%)*2
:fontcheck
set /a triplefontsize=%fontsize%*3
if %triplefontsize% gtr %desiredheight% (
    set /a fontsize=%fontsize%-5
    goto fontcheck
)
:: does the same thing but for text two
:fontcheck2
set /a triplefontsizebottom=%fontsizebottom%*3
if %triplefontsizebottom% gtr %desiredheight% (
    set /a fontsizebottom=%fontsizebottom%-5
    goto fontcheck2
)
:: setting text filter
set "textfilter=drawtext=borderw=(%fontsize%/12):fontfile=C\\:/Windows/Fonts/impact.ttf:text='%toptext%':fontcolor=white:fontsize=%fontsize%:x=(w-text_w)/2:y=(0.25*text_h),drawtext=borderw=(%fontsizebottom%/12):fontfile=C\\:/Windows/Fonts/impact.ttf:text='%bottomtext%':fontcolor=white:fontsize=%fontsizebottom%:x=(w-text_w)/2:y=(h-1.25*text_h)"
goto :eof