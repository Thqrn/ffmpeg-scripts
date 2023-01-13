:: mask blur - a script to mask out blur in a video, with the input provided and output fetched
:: Copyright (C) 2022 Thqrn

:: This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
:: This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
:: You should have received a copy of the GNU General Public License along with this program. If not, see http://www.gnu.org/licenses/.

:: made by Frost#5872
:: https://github.com/Thqrn/ffmpeg-scripts

@echo off
:: set this variable to false if you want to manually find the original file and skip the checks
set automatic=true
:: set this to the path of the mask
set mask="%temp%\ALPHAMASK.png"

SET mypath=%~dp0
for %%a in (%*) do (
    call :audiofix %%a
)
where /q ffplay || exit
if not exist "C:\Windows\Media\notify.wav" (exit) else ffplay "C:\Windows\Media\notify.wav" -volume 50 -autoexit -showmode 0 -loglevel quiet
exit

:audiofix
:: defines input video
set "inputvideo=%~dpn1"
:: finds duration of input video
ffprobe -i "%inputvideo%.mp4" -show_entries format=duration -v quiet -of csv="p=0" > %temp%\fileoneduration.txt
:: rewebmes " - blur" from the input video's name in an attempt to automatically find the before
if %automatic% == false (
    echo Automatic file finding is disabled.
	 goto skipped
)
:: CHANGE THE " - blur" TO WHATEVER YOUR SUFFIX IS
if %automatic% == true (
     set "inputoriginalmaybe=%inputvideo: - blur=%"
)
if %automatic% == true (
	 if exist "%inputoriginalmaybe%.mp4" set inputoriginalmaybe="%inputoriginalmaybe%.mp4"
	 if exist "%inputoriginalmaybe%.mp4" goto actualstuff
)
if %automatic% == true (
	 if exist "%inputoriginalmaybe%).mp4" set inputoriginalmaybe="%inputoriginalmaybe%).mp4"
	 if exist "%inputoriginalmaybe%).mp4" goto skipped
)
:skipped
if %automatic% == false (
	 echo For reference, the file you're using as the input here is "%inputvideo%.mp4"
	 set /p inputoriginalmaybe=Please drag in the pre-blur file here: 
	 goto actualstuff
)
:actualstuff
if "%inputvideo%.mp4" == %inputoriginalmaybe% (
    echo Original file was unable to be found automatically. The input file may not have been the post-blur video.
	 set automatic=false
	 goto skipped
)
ffprobe -v error -select_streams v:0 -show_entries stream=r_frame_rate -i %1 -of csv=p=0 > %temp%\fpsv.txt
set /p fpsvalue=<%temp%\fpsv.txt
if exist "%temp%\fpsv.txt" (del "%temp%\fpsv.txt")
:: finds duration of original video
ffprobe -i %inputoriginalmaybe% -show_entries format=duration -v quiet -of csv="p=0" > %temp%\filetwoduration.txt
:: sets them to variables
set /p fod=<%temp%\fileoneduration.txt
set /p ftd=<%temp%\filetwoduration.txt
set "speed=%fod%/%ftd%"
if not exist %mask% (curl -s -o %mask% https://i.ibb.co/t89PC4s/example.png > nul)
ffmpeg -hide_banner -stats_period 0.5 -loglevel error -stats -i %inputoriginalmaybe% -i %mask% -pix_fmt rgba -c:v png -an -filter_complex "setpts=(%speed%)*PTS,fps=%fpsvalue%,alphamerge" "%temp%\thisisanexample.mov"
ffmpeg -hide_banner -stats_period 0.5 -loglevel error -stats -i %1 -i "%temp%\thisisanexample.mov" -filter_complex overlay -c:a:0 copy -c:v libx264 -preset slow -crf 16 -aq-mode 3 "%~dpn1 (masked).mp4"
:: deletes temp files
if exist "%temp%\fileoneduration.txt" (del "%temp%\fileoneduration.txt")
if exist "%temp%\filetwoduration.txt" (del "%temp%\filetwoduration.txt")
if exist "%temp%\thisisanexample.mov" (del "%temp%\thisisanexample.mov")
goto :eof