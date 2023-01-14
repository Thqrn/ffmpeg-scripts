:: mask blur - a script to mask out blur in a video, with the input provided and output fetched
:: Copyright (C) 2022 Thqrn

:: This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
:: This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
:: You should have received a copy of the GNU General Public License along with this program. If not, see http://www.gnu.org/licenses/.

:: made by Frost#5872
:: https://github.com/Thqrn/ffmpeg-scripts

@echo off
setlocal enabledelayedexpansion
:: set this variable to false if you want to manually find the original file and skip the checks
set automatic=true
:: resample the original video when masking to help it blend in better
set resample=false
:: set this to the path of the mask
if exist "%temp%/maskblurtemp" (rmdir /s /q "%temp%/maskblurtemp")
mkdir "%temp%/maskblurtemp"
set maskblurtemp=%temp%/maskblurtemp
set mask="D:\Videos\Clips\obs\resample testing\ALPHAMAS2K.png"

SET mypath=%~dp0
for %%a in (%*) do (
    call :audiofix %%a
)
where /q ffplay || exit
if not exist "C:\Windows\Media\notify.wav" (exit) else ffplay "C:\Windows\Media\notify.wav" -volume 50 -autoexit -showmode 0 -loglevel quiet
exit

:audiofix
:: defines input video
set "blurredvid=%1"
:: finds duration of input video
ffprobe -i %blurredvid% -show_entries format=duration -v quiet -of csv="p=0" > %maskblurtemp%\fileoneduration.txt
:: rewebmes " - blur" from the input video's name in an atmaskblurtempt to automatically find the before
:: CHANGE THE " - blur" TO WHATEVER YOUR SUFFIX IS
if "%automatic%" == "true" (
    set "ogvid=%blurredvid: - blur=%"
    if exist !ogvid! (
        if !ogvid! NEQ %blurredvid% goto afterfound
    )
    set ogvid="%~dpn1 - blur%~x1"
    if not exist !ogvid! (
        goto skipped
    ) else (
        set blurredvid=!ogvid!
        set "ogvid=%blurredvid%"
    )
)
:afterfound
echo Original Input Video: !ogvid!
echo Blurred Video: !blurredvid!
echo Mask: %mask%
echo Resample Enabled: %resample%
ffprobe -v error -select_streams v:0 -show_entries stream=r_frame_rate -i %blurredvid% -of csv=p=0 > %maskblurtemp%\fpsv.txt
set /p fpsvalue=<%maskblurtemp%\fpsv.txt
set /a fpsvalue=%fpsvalue%
if exist "%maskblurtemp%\fpsv.txt" (del "%maskblurtemp%\fpsv.txt")
if %fpsvalue% gtr 90 (
    echo WARNING: Your video has a framerate of %fpsvalue%, indicating that you may have inputted the INPUT file for blur, and not
    echo the OUTPUT. Either try again with the OUTPUT file, or press [Y] to continue anyway.
    set /p continue=Continue? [Y/N]
    if not "!continue!" == "Y" exit
)
:: finds duration of original video
ffprobe -i %ogvid% -show_entries format=duration -v quiet -of csv="p=0" > %maskblurtemp%\filetwoduration.txt
:: sets them to variables
set /p fod=<%maskblurtemp%\fileoneduration.txt
set /p ftd=<%maskblurtemp%\filetwoduration.txt
set "speed=%fod%/%ftd%"
if not exist %mask% (curl -s -o %mask% https://i.ibb.co/t89PC4s/example.png > nul)
if %resample% == true (
    ffmpeg -hide_banner -stats_period 0.5 -loglevel error -stats -i %ogvid% -i %mask% -pix_fmt rgba -c:v png -an -filter_complex "setpts=(%speed%)*PTS,tmix=frames=%fpsvalue%,fps=%fpsvalue%,alphamerge" "%maskblurtemp%\thisisanexample.mov"
) else (
    ffmpeg -hide_banner -stats_period 0.5 -loglevel error -stats -i %ogvid% -i %mask% -pix_fmt rgba -c:v png -an -filter_complex "setpts=(%speed%)*PTS,fps=%fpsvalue%,alphamerge" "%maskblurtemp%\thisisanexample.mov"
)
ffmpeg -hide_banner -stats_period 0.5 -loglevel error -stats -i %blurredvid% -i "%maskblurtemp%\thisisanexample.mov" -filter_complex overlay -c:a:0 copy -c:v libx264 -preset slow -crf 15 -aq-mode 3 "%~dpn1 (masked).mp4"
:: deletes maskblurtemp files
if exist "%maskblurtemp%\fileoneduration.txt" (del "%maskblurtemp%\fileoneduration.txt")
if exist "%maskblurtemp%\filetwoduration.txt" (del "%maskblurtemp%\filetwoduration.txt")
if exist "%maskblurtemp%\thisisanexample.mov" (del "%maskblurtemp%\thisisanexample.mov")
if exist maskblurtemp (rmdir /s /q maskblurtemp)
goto :eof

:skipped
echo ERROR: Original (unblurred) file not found. Please provide it manually.
echo For reference, the BLURRED file should be %blurredvid%.
set /p ogvid=Please drag in the pre-blur file here: 
goto afterfound