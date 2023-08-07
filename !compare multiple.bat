:: This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
:: This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
:: You should have received a copy of the GNU General Public License along with this program. If not, see http://www.gnu.org/licenses/.

:: Copyright 2023 Thqrn. Licensed under the GNU General Public License v3.0.

:: @froest on Discord
:: https://github.com/Thqrn/ffmpeg-scripts

@echo off

:: OPTIONS
:: preserve input aspect ratios
set preservear=true

:: actual code
set temp=%temp%\tempfolder
rmdir %temp% /s /q > nul 2> nul
mkdir %temp%
if exist "%temp%\height.txt" (del "%temp%\height.txt")
if exist "%temp%\width.txt" (del "%temp%\width.txt")
ffprobe -v error -select_streams v:0 -show_entries stream=width -i %1 -of csv=p=0 > %temp%\width.txt
ffprobe -v error -select_streams v:0 -show_entries stream=height -i %1 -of csv=p=0 > %temp%\height.txt
set /p height=<%temp%\height.txt
set /p width=<%temp%\width.txt
if exist "%temp%\height.txt" (del "%temp%\height.txt")
if exist "%temp%\width.txt" (del "%temp%\width.txt")
for %%a in (%*) do (
   call :filecounter
)
goto sizecheck
:aftersizecheck
ffprobe -v error -select_streams v:0 -show_entries stream=r_frame_rate -i %1 -of csv=p=0 > %temp%\fps.txt
set /p fpsvalue=<%temp%\fps.txt
if exist "%temp%\fps.txt" (del "%temp%\fps.txt")
for %%a in (%*) do (
   set inputvideo=%%a
   set inputvideo2=%%~na
   call :gethighestfps
)
for %%a in (%*) do (
   set inputvideo=%%a
   set inputvideo2=%%~na
   call :scalecorrectly
)
for %%a in (%*) do (
   set inputvideo=%%a
   set inputvideo2=%%~na
   call :combine
)
ffmpeg -hide_banner -loglevel warning -stats%allinputs% -c:v libx264 -x264-params aq-mode=3 -crf 17 -filter_complex hstack=inputs=%i% "%name%.mp4"
echo.
echo [96mOutput is located at:
echo [93m"%cd%\%name%.mp4"[96m
where /q ffplay || goto conti
if not exist "C:\Windows\Media\notify.wav" (goto conti) else ffplay "C:\Windows\Media\notify.wav" -volume 50 -autoexit -showmode 0 -loglevel quiet
:conti
rmdir %temp% /s /q > nul
choice /m "Do you want to open the output file?"
if %errorlevel% == 1 "%cd%\%name%.mp4"
if %errorlevel% == 2 exit
exit

:scalecorrectly
ffmpeg -hide_banner -loglevel warning -stats -i %inputvideo% -vf scale=%width%:%height%:flags=neighbor,setsar=1:1,format=yuv420p,pad=ceil(%width%/2)*2:ceil(%height%/2)*2 -c:v libx264 -x264-params aq-mode=3 -crf 17 -c:a copy -r %highestfps% "%temp%\%inputvideo2%scaled.mp4"
goto :eof

:combine
set name=%inputvideo2% + %name%
set name=%name:~0,200%
set /a "i+=1"
set allinputs=%allinputs% -i "%temp%\%inputvideo2%scaled.mp4"
goto :eof

:gethighestfps
set /a fpsvalue1=%fpsvalue%
ffprobe -v error -select_streams v:0 -show_entries stream=r_frame_rate -i %inputvideo% -of csv=p=0 > %temp%\fps.txt
set /p fpsvalue=<%temp%\fps.txt
set /a fpsvalue=%fpsvalue%
if %fpsvalue% geq %fpsvalue1% set highestfps=%fpsvalue%
if exist "%temp%\fps.txt" (del "%temp%\fps.txt")
goto :eof

:sizecheck
set ogwidth=%width%
set /a totalwidth=%width%*%filecount%
if %totalwidth% gtr 15000 set /a width=15000/%filecount%
if not %ogwidth% == %width% set "height=((%width%/%ogwidth%)*%height%)"
set /a width=(%width%/2)*2
if preservear == true set height=-2
goto aftersizecheck

:filecounter
set /a filecount=%filecount%+1
goto :eof